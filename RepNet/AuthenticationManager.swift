//
//  AuthenticationManager.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import Foundation

// Este objeto controlará el estado de autenticación de toda la app.
class AuthenticationManager: ObservableObject {
    
    @Published var isAuthenticated = false
    // Aquí podríamos guardar el token de autenticación que nos dé la API.
    // @Published var authToken: String? = nil

    func login() {
        // Lógica para simular un inicio de sesión exitoso
        isAuthenticated = true
        print("User has been authenticated.")
    }

    func logout() {
        // Lógica para cerrar la sesión
        isAuthenticated = false
        print("User has been logged out.")
    }
}