//
//  UserAPIService.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//


import Foundation

/// Un servicio dedicado exclusivamente a las llamadas de red relacionadas con el perfil del usuario.
struct UserAPIService {
    
    private let networkClient = NetworkClient()
    
    /// Recupera el perfil del usuario que ha iniciado sesión.
    func fetchUserProfile() async throws -> UserProfileResponseDTO {
        return try await networkClient.request(
            endpoint: AppConfig.userProfileURL,
            method: "GET",
            // Le decimos al NetworkClient que esta es una petición protegida
            // y que debe adjuntar el accessToken.
            isAuthenticated: true
        )
    }
    
    // --- NUEVA FUNCIÓN AÑADIDA ---
    
    /// Envía los datos actualizados del perfil del usuario al backend.
    /// - Parameter data: Un DTO que contiene los campos a actualizar y la contraseña actual para autorización.
    func updateUserProfile(data: UpdateProfileRequestDTO) async throws {
        // Usamos el método "PATCH" que es ideal para actualizaciones parciales,
        // pero "PUT" también es común. ¡Confirma cuál usa tu backend!
        try await networkClient.request(
            endpoint: AppConfig.userProfileURL,
            method: "PATCH",

            // Pasamos el DTO con los datos del formulario como el cuerpo de la petición.
            body: data,
            
            // Esta también es una petición protegida que requiere el token.
            isAuthenticated: true
        )
    }
    
    // En el futuro, podríamos añadir la función para borrar la cuenta.
    // func deleteUser(password: String) async throws { ... }
}
