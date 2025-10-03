//
//  LoginViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    
    // --- NUEVA PROPIEDAD ---
    // Creamos una instancia de nuestro servicio de autenticación dedicado.
    private let authAPIService = AuthAPIService()
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    var isFormValid: Bool { !email.isEmpty && email.esCorreoValido && !password.isEmpty }
    
    func login(with authManager: AuthenticationManager) async {
        isLoading = true
        errorMessage = nil
        
        let credentials = LoginRequestDTO(email: email, password: password)
        
        do {
            // --- CAMBIO AQUÍ ---
            // Llamamos a la función 'login' de nuestro nuevo 'authAPIService'.
            let response = try await authAPIService.login(credentials: credentials)
            
            try KeychainService.saveTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
            
            print("Login exitoso para el usuario: \(response.user.name)")
            
            authManager.login()
            
        } catch {
            if let apiError = error as? APIError {
                switch apiError {
                case .serverError(let message):
                    errorMessage = message
                case .invalidResponse(let code):
                    errorMessage = "Error del servidor (código: \(code))."
                case .decodingError:
                    errorMessage = "La respuesta del servidor no es válida."
                default:
                    errorMessage = "Ocurrió un error. Inténtalo de nuevo."
                }
            } else {
                errorMessage = "No se pudo conectar. Revisa tu conexión."
            }
        }
        
        isLoading = false
    }
}
