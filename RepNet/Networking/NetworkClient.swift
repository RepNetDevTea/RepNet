//
//  NetworkClient.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case serverError(message: String)
}

struct NetworkClient {
    
    func request<T: Decodable>(endpoint: String, method: String, body: (any Encodable)? = nil, isAuthenticated: Bool = false) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if isAuthenticated {
            guard let token = KeychainService.getAccessToken() else {
                print("❌ Error: No se encontró el accessToken en el Keychain para una petición autenticada.")
                throw APIError.serverError(message: "No authentication token found.")
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // --- NUEVA LÍNEA PARA DEPURACIÓN ---
        // Imprimimos la petición completa que estamos a punto de enviar.
        print("➡️ Enviando Petición: \(request.httpMethod ?? "") a \(endpoint)")
        print("   Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: 0)
        }
        
        // Imprimimos el código de estado que recibimos.
        print("⬅️ Respuesta recibida con código: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data), let message = errorResponse["message"] {
                throw APIError.serverError(message: message)
            }
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // La otra función 'request' no necesita cambios por ahora.
    func request(endpoint: String, method: String, body: (any Encodable)? = nil, isAuthenticated: Bool = false) async throws {
        // ... (lógica existente)
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if isAuthenticated {
            guard let token = KeychainService.getAccessToken() else { throw APIError.serverError(message: "No authentication token found.") }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body { request.httpBody = try JSONEncoder().encode(body) }
        print("➡️ Enviando Petición: \(request.httpMethod ?? "") a \(endpoint)")
        print("   Headers: \(request.allHTTPHeaderFields ?? [:])")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse(statusCode: 0) }
        print("⬅️ Respuesta recibida con código: \(httpResponse.statusCode)")
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data), let message = errorResponse["message"] {
                throw APIError.serverError(message: message)
            }
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
}
