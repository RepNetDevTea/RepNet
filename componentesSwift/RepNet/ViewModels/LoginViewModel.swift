//
//  LoginViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    var isFormValid: Bool { !email.isEmpty && email.contains("@") && !password.isEmpty }
    
    // login usa authenticator manager como parametro
    func login(with authManager: AuthenticationManager) {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.email.lowercased() == "angel@tec.com" && self.password == "password" {
                print("Login successful!")
                // si tiene exito, se llama el metodo de login al gestor
                authManager.login()
            } else {
                self.errorMessage = "Correo y/o contraseña incorrectos."
            }
            self.isLoading = false
        }
    }
}
