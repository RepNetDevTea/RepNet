//
//  AuthAPIService.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//


import Foundation

/// Un servicio dedicado exclusivamente a las llamadas de red relacionadas con la autenticación.
struct AuthAPIService {
    
    private let networkClient = NetworkClient()
    
    /// Realiza la llamada de login al backend.
    func login(credentials: LoginRequestDTO) async throws -> LoginResponseDTO {
        
        // --- NUEVA LÍNEA PARA DEPURACIÓN ---
        // Vamos a imprimir el JSON que estamos a punto de enviar.
        // Esto nos permitirá ver exactamente qué está recibiendo el backend.
        if let data = try? JSONEncoder().encode(credentials), let jsonString = String(data: data, encoding: .utf8) {
            print("📤 Enviando JSON al servidor:\n\(jsonString)")
        }
        
        return try await networkClient.request(
            endpoint: AppConfig.loginURL,
            method: "POST",
            body: credentials
        )
    }
    
    /// Realiza la llamada de registro (signUp) al backend.
    func signUp(userData: SignUpRequestDTO) async throws {
        
        // --- AÑADIMOS DEPURACIÓN AQUÍ TAMBIÉN ---
        if let data = try? JSONEncoder().encode(userData), let jsonString = String(data: data, encoding: .utf8) {
            print("📤 Enviando JSON de registro al servidor:\n\(jsonString)")
        }
        
        // Usamos la versión del 'request' que no espera un cuerpo de respuesta.
        try await networkClient.request(
            endpoint: AppConfig.registerURL,
            method: "POST",
            body: userData
        )
    }
}
