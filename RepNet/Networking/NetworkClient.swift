//
//  NetworkClient.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//

import Foundation

// un enum con errores personalizados para la capa de red.
// esto nos ayuda a saber exactamente que tipo de error ocurrio en lugar de un error generico.
enum APIError: Error {
    case invalidURL                // la url que se le paso no es valida.
    case invalidResponse(statusCode: Int) // la respuesta del servidor no fue la esperada (ej. un error 404 o 500).
    case decodingError(Error)      // no se pudo convertir el json de la respuesta a nuestros objetos swift.
    case serverError(message: String) // el servidor devolvio un mensaje de error especifico en el json.
}

// este es el cliente de red generico y reutilizable. es la base de todas las llamadas a la api.
// los "apiservice" mas especificos (como `authapiservice`) usan este cliente para hacer el trabajo real.
struct NetworkClient {
    
    // esta funcion es para peticiones que devuelven datos (un objeto json).
    // es generica (`<t>`), por lo que puede decodificar cualquier tipo de objeto que sea `decodable`.
    func request<T: Decodable>(endpoint: String, method: String, body: (any Encodable)? = nil, isAuthenticated: Bool = false) async throws -> T {
        
        // 1. crear la url y la peticion basica.
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 2. si la peticion requiere autenticacion, se anade el token del keychain.
        if isAuthenticated {
            guard let token = KeychainService.getAccessToken() else {
                print("❌ error: no se encontro el accesstoken para una peticion autenticada.")
                throw APIError.serverError(message: "no se encontro el token de autenticacion.")
            }
            request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // 3. si la peticion tiene un cuerpo (body), se codifica a json.
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // bloque de depuracion para ver la peticion completa que se esta enviando.
        print("➡️ enviando peticion: \(request.httpMethod ?? "") a \(endpoint)")
        print("   headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // 4. se ejecuta la llamada a la red.
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse(statusCode: 0)
        }
        
        // bloque de depuracion para ver el codigo de estado de la respuesta.
        print("⬅️ respuesta recibida con codigo: \(httpResponse.statusCode)")
        
        // 5. se valida que el codigo de estado este en el rango de exito (200-299).
        guard (200...299).contains(httpResponse.statusCode) else {
            // 6. si el codigo es de error, intentamos leer un mensaje de error especifico del json.
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data), let message = errorResponse["message"] {
                throw APIError.serverError(message: message)
            }
            // si no se puede, lanzamos un error generico con el codigo de estado.
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        // 7. si todo salio bien, se decodifica el json de respuesta al tipo `t` esperado.
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            // si la decodificacion falla, lanzamos un error especifico de decodificacion.
            throw APIError.decodingError(error)
        }
    }
    
    // esta es una sobrecarga de la funcion para peticiones donde no esperamos recibir datos de vuelta
    // (ej. un registro de usuario o un delete). solo nos importa si la operacion fue exitosa.
    func request(endpoint: String, method: String, body: (any Encodable)? = nil, isAuthenticated: Bool = false) async throws {
        guard let url = URL(string: endpoint) else { throw APIError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if isAuthenticated {
            guard let token = KeychainService.getAccessToken() else { throw APIError.serverError(message: "no authentication token found.") }
            request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if let body = body { request.httpBody = try JSONEncoder().encode(body) }
        print("➡️ enviando peticion: \(request.httpMethod ?? "") a \(endpoint)")
        print("   headers: \(request.allHTTPHeaderFields ?? [:])")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse(statusCode: 0) }
        print("⬅️ respuesta recibida con codigo: \(httpResponse.statusCode)")
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data), let message = errorResponse["message"] {
                throw APIError.serverError(message: message)
            }
            throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
}
