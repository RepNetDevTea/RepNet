//
//  AccountViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import Foundation
import Combine

// este archivo es el viewmodel para la pantalla de "mi cuenta".
// las llamadas a la api y la validacion del formulario.
// `@mainactor` asegura que todas las actualizaciones para la ui se hagan en el hilo principal.
@MainActor
class AccountViewModel: ObservableObject {
    
    // una instancia del servicio de api para el perfil de usuario.
    private let userAPIService = UserAPIService()
    
    // -- datos del perfil --
    @Published var name = ""
    @Published var fathersLastName = ""
    @Published var mothersLastName = ""
    @Published var email = ""
    @Published var username = ""
    
    // -- estado de la ui --
    @Published var isEditing = false
    @Published var showSuccessBanner = false
    @Published var showLogoutAlert = false
    @Published var showDeleteAlert = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // -- campos para cambiar contrasena --
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var passwordValidationStates: [PasswordRequirement: ValidationState] = PasswordValidator.validate(password: "")
    @Published var passwordsMatch: ValidationState = .neutral
    @Published var isFormValid = false
    
    // guarda las suscripciones de combine para que se puedan cancelar y evitar fugas de memoria.
    private var cancellables = Set<AnyCancellable>()

    // el inicializador configura la validacion reactiva.
    init() {
        setupValidation()
    }
    
    // obtiene los datos del perfil del usuario desde la api y actualiza las propiedades.
    func fetchUserProfile() async {
        isLoading = true
        errorMessage = nil
        print("🚀 intentando obtener el perfil del usuario...")
        do {
            let userProfile = try await userAPIService.fetchUserProfile()
            self.name = userProfile.name
            self.fathersLastName = userProfile.fathersLastName
            self.mothersLastName = userProfile.mothersLastName
            self.email = userProfile.email
            self.username = userProfile.username
            print("✅ perfil de usuario obtenido exitosamente.")
        } catch {
            print("❌ error al obtener el perfil del usuario: \(error)")
            handle(error: error)
        }
        isLoading = false
    }
    
    // envia los cambios del formulario al backend.
    func saveChanges() async {
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        let updateData = UpdateProfileRequestDTO(name: name, fathersLastName: fathersLastName, mothersLastName: mothersLastName, username: username, email: email, currentPassword: currentPassword, newPassword: newPassword.isEmpty ? nil : newPassword)
        do {
            try await userAPIService.updateUserProfile(data: updateData)
            isEditing = false
            showSuccessBanner = true
            currentPassword = ""; newPassword = ""; confirmPassword = ""
            // oculta el banner de exito despues de 3 segundos.
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showSuccessBanner = false
            }
        } catch {
            handle(error: error)
        }
        isLoading = false
    }
    
    // una funcion auxiliar para convertir errores de la api en mensajes para el usuario.
    private func handle(error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let message):
                self.errorMessage = message
            case .invalidResponse(let statusCode):
                self.errorMessage = "error del servidor: \(statusCode). intentalo de nuevo."
            case .decodingError:
                self.errorMessage = "la respuesta del servidor no tiene el formato esperado."
            default:
                self.errorMessage = "ocurrio un error de red. intentalo de nuevo."
            }
        } else {
            self.errorMessage = "no se pudo conectar. revisa tu conexion."
        }
    }
    
    // configura la validacion reactiva del formulario usando combine.
    // esto hace que los requisitos de la contrasena se validen mientras el usuario escribe.
    private func setupValidation() {
        // cada vez que `newpassword` cambia, se vuelve a validar con `passwordvalidator`.
        $newPassword.removeDuplicates().sink { [weak self] pass in
            self?.passwordValidationStates = PasswordValidator.validate(password: pass)
            self?.validatePasswordsMatch()
        }.store(in: &cancellables)
        
        // cada vez que `confirmpassword` cambia, se revisa si coincide con `newpassword`.
        $confirmPassword.removeDuplicates().sink { [weak self] _ in
            self?.validatePasswordsMatch()
        }.store(in: &cancellables)
        
        // `combinelatest3` observa varios campos a la vez y recalcula `isformvalid`
        // cada vez que uno de ellos cambia. el formulario es valido si:
        // 1. la contrasena actual no esta vacia.
        // 2. la nueva contrasena esta vacia O (cumple todos los requisitos y coincide con la confirmacion).
        Publishers.CombineLatest3($currentPassword, $passwordValidationStates, $passwordsMatch)
            .map { currentPass, states, match in
                let isNewPasswordValid = self.newPassword.isEmpty || (states.allSatisfy { $0.value == .success } && match == .success)
                return !currentPass.isEmpty && isNewPasswordValid
            }.assign(to: \.isFormValid, on: self).store(in: &cancellables)
    }
    
    // una funcion auxiliar para validar si las contrasenas coinciden.
    private func validatePasswordsMatch() {
        if confirmPassword.isEmpty && newPassword.isEmpty { passwordsMatch = .neutral; return }
        passwordsMatch = newPassword == confirmPassword ? .success : .failure
    }
}
