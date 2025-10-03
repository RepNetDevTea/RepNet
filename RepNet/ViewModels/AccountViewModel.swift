//
//  AccountViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import Foundation
import Combine

@MainActor
class AccountViewModel: ObservableObject {
    
    private let userAPIService = UserAPIService()
    
    // Propiedades de estado (sin cambios)
    @Published var name = ""
    @Published var fathersLastName = ""
    @Published var mothersLastName = ""
    @Published var email = ""
    @Published var username = ""
    @Published var isEditing = false
    @Published var showSuccessBanner = false
    @Published var showLogoutAlert = false
    @Published var showDeleteAlert = false
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var passwordValidationStates: [PasswordRequirement: ValidationState] = PasswordValidator.validate(password: "")
    @Published var passwordsMatch: ValidationState = .neutral
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupValidation()
    }
    
    func fetchUserProfile() async {
        isLoading = true
        errorMessage = nil
        print("🚀 Intentando obtener el perfil del usuario...")
        do {
            let userProfile = try await userAPIService.fetchUserProfile()
            self.name = userProfile.name
            self.fathersLastName = userProfile.fathersLastName
            self.mothersLastName = userProfile.mothersLastName
            self.email = userProfile.email
            self.username = userProfile.username
            print("✅ Perfil de usuario obtenido exitosamente.")
        } catch {
            // --- CAMBIO CLAVE AQUÍ ---
            // Ahora imprimimos el error real en la consola para un mejor diagnóstico.
            print("❌ Error al obtener el perfil del usuario: \(error)")
            handle(error: error)
        }
        isLoading = false
    }
    
    func saveChanges() async {
        // ... (esta función se mantiene igual)
        guard isFormValid else { return }
        isLoading = true
        errorMessage = nil
        let updateData = UpdateProfileRequestDTO(name: name, fathersLastName: fathersLastName, mothersLastName: mothersLastName, username: username, email: email, currentPassword: currentPassword, newPassword: newPassword.isEmpty ? nil : newPassword)
        do {
            try await userAPIService.updateUserProfile(data: updateData)
            isEditing = false
            showSuccessBanner = true
            currentPassword = ""; newPassword = ""; confirmPassword = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showSuccessBanner = false
            }
        } catch {
            handle(error: error)
        }
        isLoading = false
    }
    
    // --- FUNCIÓN DE MANEJO DE ERRORES MEJORADA ---
    private func handle(error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let message):
                self.errorMessage = message
            case .invalidResponse(let statusCode):
                // Damos un mensaje más específico si sabemos el código de estado.
                self.errorMessage = "Error del servidor: \(statusCode). Inténtalo de nuevo."
            case .decodingError:
                self.errorMessage = "La respuesta del servidor no tiene el formato esperado."
            default:
                self.errorMessage = "Ocurrió un error de red. Inténtalo de nuevo."
            }
        } else {
            self.errorMessage = "No se pudo conectar. Revisa tu conexión."
        }
    }
    
    // ... (El resto del archivo: setupValidation, etc. se mantiene igual)
    private func setupValidation() {
        $newPassword.removeDuplicates().sink { [weak self] pass in
            self?.passwordValidationStates = PasswordValidator.validate(password: pass)
            self?.validatePasswordsMatch()
        }.store(in: &cancellables)
        $confirmPassword.removeDuplicates().sink { [weak self] _ in
            self?.validatePasswordsMatch()
        }.store(in: &cancellables)
        Publishers.CombineLatest3($currentPassword, $passwordValidationStates, $passwordsMatch)
            .map { currentPass, states, match in
                let isNewPasswordValid = self.newPassword.isEmpty || (states.allSatisfy { $0.value == .success } && match == .success)
                return !currentPass.isEmpty && isNewPasswordValid
            }.assign(to: \.isFormValid, on: self).store(in: &cancellables)
    }
    private func validatePasswordsMatch() {
        if confirmPassword.isEmpty && newPassword.isEmpty { passwordsMatch = .neutral; return }
        passwordsMatch = newPassword == confirmPassword ? .success : .failure
    }
}
