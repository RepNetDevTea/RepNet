//
//  SignUpViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    // MARK: - Input Properties
    @Published var name = ""
    @Published var lastName = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // MARK: - Validation State Properties
    @Published var passwordValidationStates: [PasswordRequirement: ValidationState] = [
        .minLength: .neutral,
        .maxLength: .neutral,
        .hasUppercase: .neutral,
        .hasNumber: .neutral,
        .hasSpecialChar: .neutral
    ]
    @Published var passwordsMatch: ValidationState = .neutral
    @Published var isEmailValid: ValidationState = .neutral
    @Published var emailErrorMessage: String? = nil
    @Published var passwordErrorMessage: String? = nil
    
    // MARK: - UI State
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()

    // Enum para los requisitos, para un código más limpio
    enum PasswordRequirement: String, CaseIterable {
        case minLength = "8 caracteres mínimo."
        case maxLength = "20 caracteres máximo."
        case hasUppercase = "1 letra mayúscula."
        case hasNumber = "1 número."
        case hasSpecialChar = "1 caracter especial (# ! % $)."
    }

    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        // --- Validación de Contraseña en tiempo real ---
        $password
            .removeDuplicates()
            .sink { [weak self] pass in
                self?.validatePassword(pass)
                self?.validatePasswordsMatch(pass1: pass, pass2: self?.confirmPassword ?? "")
            }
            .store(in: &cancellables)
            
        // --- Validación de Coincidencia de Contraseñas ---
        $confirmPassword
            .removeDuplicates()
            .sink { [weak self] confirmPass in
                self?.validatePasswordsMatch(pass1: self?.password ?? "", pass2: confirmPass)
            }
            .store(in: &cancellables)
        
        // --- Validación de Correo ---
        $email
            .debounce(for: 0.5, scheduler: RunLoop.main) // Espera a que el usuario deje de teclear
            .removeDuplicates()
            .sink { [weak self] email in
                self?.validateEmail(email)
            }
            .store(in: &cancellables)
            
        // --- Validador del Formulario Completo ---
        Publishers.CombineLatest3(
            $passwordValidationStates,
            $passwordsMatch,
            $isEmailValid
        )
        .combineLatest($name, $lastName)
        .map { [weak self] validation, name, lastName in
            let arePasswordsValid = validation.0.allSatisfy { $0.value == .success }
            let doPasswordsMatch = validation.1 == .success
            let isEmailValid = validation.2 == .success
            let areNamesFilled = !name.isEmpty && !lastName.isEmpty
            
            // Si el correo ya existe, el formulario no es válido
            if self?.emailErrorMessage != nil { return false }
            
            return arePasswordsValid && doPasswordsMatch && isEmailValid && areNamesFilled
        }
        .assign(to: \.isFormValid, on: self)
        .store(in: &cancellables)
    }
    
    // MARK: - Validation Logic
    private func validatePassword(_ pass: String) {
        if pass.isEmpty {
            PasswordRequirement.allCases.forEach { passwordValidationStates[$0] = .neutral }
            return
        }
        passwordValidationStates[.minLength] = pass.count >= 8 ? .success : .failure
        passwordValidationStates[.maxLength] = pass.count <= 20 ? .success : .failure
        passwordValidationStates[.hasUppercase] = pass.rangeOfCharacter(from: .uppercaseLetters) != nil ? .success : .failure
        passwordValidationStates[.hasNumber] = pass.rangeOfCharacter(from: .decimalDigits) != nil ? .success : .failure
        passwordValidationStates[.hasSpecialChar] = pass.range(of: "[#!%$]", options: .regularExpression) != nil ? .success : .failure
    }
    
    private func validatePasswordsMatch(pass1: String, pass2: String) {
        if pass2.isEmpty {
            passwordsMatch = .neutral
            passwordErrorMessage = nil
            return
        }
        passwordsMatch = pass1 == pass2 ? .success : .failure
        passwordErrorMessage = pass1 == pass2 ? nil : "Las contraseñas no coinciden."
    }
    
    private func validateEmail(_ email: String) {
        if email.isEmpty {
            isEmailValid = .neutral
            emailErrorMessage = nil
            return
        }
        // Simulación de correo existente
        if email.lowercased() == "angel@tec.com" {
            isEmailValid = .failure
            emailErrorMessage = "El correo ya existe."
            return
        }
        // Regex para validar formato de correo
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        isEmailValid = emailPredicate.evaluate(with: email) ? .success : .failure
        emailErrorMessage = isEmailValid == .success ? nil : "El formato del correo no es válido."
    }
    
    func signUp() {
        // Aquí iría la llamada a la API para registrar al usuario
        print("Registrando usuario...")
    }
}
