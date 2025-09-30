//
//  AccountViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import Foundation
import Combine

class AccountViewModel: ObservableObject {
    // MARK: - User Data
    @Published var name = "Angel"
    @Published var lastName = "Lopez"
    @Published var username = "durandal"
    @Published var email = "angel@tec.com"
    
    // MARK: - UI State
    @Published var isEditing = false
    @Published var showSuccessBanner = false
    @Published var showLogoutAlert = false
    @Published var showDeleteAlert = false
    @Published var isFormValid = true // El formulario es válido por defecto
    
    // MARK: - Password Change Properties
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var passwordValidationStates: [PasswordRequirement: ValidationState] = PasswordValidator.validate(password: "")
    @Published var passwordsMatch: ValidationState = .neutral
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        // Valida la nueva contraseña en tiempo real
        $newPassword
            .removeDuplicates()
            .sink { [weak self] pass in
                self?.passwordValidationStates = PasswordValidator.validate(password: pass)
                self?.validatePasswordsMatch()
            }
            .store(in: &cancellables)
            
        // Valida la coincidencia de contraseñas
        $confirmPassword
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.validatePasswordsMatch()
            }
            .store(in: &cancellables)
            
        // Valida el formulario completo
        Publishers.CombineLatest3($newPassword, $passwordValidationStates, $passwordsMatch)
            .map { newPass, states, match in
                // Si no se está cambiando la contraseña, el formulario es válido.
                if newPass.isEmpty { return true }
                
                // Si se está cambiando, todos los requisitos y la coincidencia deben ser exitosos.
                let allReqsMet = states.allSatisfy { $0.value == .success }
                return allReqsMet && match == .success
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    private func validatePasswordsMatch() {
        if confirmPassword.isEmpty && newPassword.isEmpty {
            passwordsMatch = .neutral
            return
        }
        passwordsMatch = newPassword == confirmPassword ? .success : .failure
    }

    func saveChanges() {
        guard isFormValid else { return }
        
        print("Guardando cambios...")
        isEditing = false
        showSuccessBanner = true
        
        // Limpia los campos de contraseña después de guardar
        newPassword = ""
        confirmPassword = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showSuccessBanner = false
        }
    }
}
