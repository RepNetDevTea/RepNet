//
//  SignUpViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import Foundation
import Combine

@MainActor
class SignUpViewModel: ObservableObject {
    
    // --- NUEVA PROPIEDAD ---
    // Creamos una instancia de nuestro servicio de autenticación dedicado.
    private let authAPIService = AuthAPIService()
    
    // Propiedades de estado (sin cambios)
    @Published var name = ""
    @Published var fathersLastName = ""
    @Published var mothersLastName = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var passwordValidationStates: [PasswordRequirement: ValidationState] = [:]
    @Published var passwordsMatch: ValidationState = .neutral
    @Published var isEmailValid: ValidationState = .neutral
    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    @Published var isFormValid = false
    @Published var isLoading = false
    @Published var registrationSuccessful = false
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupValidation()
    }
    
    // La lógica de validación se mantiene igual...
    private func setupValidation() {
        $password.removeDuplicates().sink { [weak self] pass in
            self?.passwordValidationStates = PasswordValidator.validate(password: pass)
            self?.validatePasswordsMatch(pass1: pass, pass2: self?.confirmPassword ?? "")
        }.store(in: &cancellables)
            
        $confirmPassword.removeDuplicates().sink { [weak self] confirmPass in
            self?.validatePasswordsMatch(pass1: self?.password ?? "", pass2: confirmPass)
        }.store(in: &cancellables)
        
        $email.debounce(for: 0.5, scheduler: RunLoop.main).removeDuplicates().sink { [weak self] email in
            self?.validateEmail(email)
        }.store(in: &cancellables)
            
        let areNamesFilledPublisher = Publishers.CombineLatest4($name, $fathersLastName, $mothersLastName, $username)
            .map { !$0.isEmpty && !$1.isEmpty && !$2.isEmpty && !$3.isEmpty }

        let areCredentialsValidPublisher = Publishers.CombineLatest3($passwordValidationStates, $passwordsMatch, $isEmailValid)
            .map { states, match, emailState in
                let allReqsMet = states.allSatisfy { $0.value == .success }
                return allReqsMet && match == .success && emailState == .success
            }
            
        Publishers.CombineLatest(areNamesFilledPublisher, areCredentialsValidPublisher)
            .map { $0 && $1 }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }

    private func validatePasswordsMatch(pass1: String, pass2: String) {
        if pass2.isEmpty { passwordsMatch = .neutral; passwordErrorMessage = nil; return }
        passwordsMatch = pass1 == pass2 ? .success : .failure
        passwordErrorMessage = pass1 == pass2 ? nil : "Las contraseñas no coinciden."
    }
    
    private func validateEmail(_ email: String) {
        if email.isEmpty { isEmailValid = .neutral; emailErrorMessage = nil; return }
        if !email.esCorreoValido {
            isEmailValid = .failure
            emailErrorMessage = "El formato del correo no es válido."
        } else {
            isEmailValid = .success
            emailErrorMessage = nil
        }
    }
    
    func signUp() async {
        isLoading = true
        emailErrorMessage = nil
        
        let userData = SignUpRequestDTO(
            name: name, fathersLastName: fathersLastName, mothersLastName: mothersLastName,
            username: username, email: email, password: password
        )
        
        do {
            // --- CAMBIO AQUÍ ---
            // Llamamos a la función 'signUp' de nuestro nuevo 'authAPIService'.
            try await authAPIService.signUp(userData: userData)
            
            registrationSuccessful = true
            
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .serverError(let message):
                    emailErrorMessage = message
                default:
                    emailErrorMessage = "Ocurrió un error. Intenta de nuevo."
                }
            } else {
                emailErrorMessage = "No se pudo conectar. Revisa tu conexión."
            }
        }
        
        isLoading = false
    }
}

