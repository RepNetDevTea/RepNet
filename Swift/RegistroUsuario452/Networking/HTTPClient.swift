//
//  HTTPClient.swift
//  RegistroUsuario452
//
//  Created by José Molina on 29/08/25.
//

import Foundation

struct HTTPClient {
    /*
    func UserRegistration(name:String, email:String, password:String) async throws -> RegistrationFormResponse{
        let requestForm = RegistrationFormRequest(name: name, fatherLastName: fatherLastName, motherLastName: motherLastName, userName: userName, email: email, password: password)
        let url = URL(string: "http://localhost:3000/users")!
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONEncoder().encode(requestForm)
        httpRequest.httpBody = jsonData
        let (data, _) = try await URLSession.shared.data(for: httpRequest)
        let response = try JSONDecoder().decode(RegistrationFormResponse.self, from: data)
        return response
    }*/
    
    func UserLogin(email: String, password: String) async throws -> LoginResponse {
        let loginRequest = LoginRequest(email: email, password: password)
        
        guard let url = URL(string: URLSettings.login) else {
                fatalError("Invalid URL: \(URLSettings.login)")
            }
        

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(loginRequest)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // ✅ Verifica el código de estado HTTP
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        print("📡 Status code: \(httpResponse.statusCode)")

        // 🧪 Imprime el contenido del cuerpo de la respuesta (JSON o texto)
        if let responseString = String(data: data, encoding: .utf8) {
            print("📥 Respuesta del servidor:\n\(responseString)")
        }

        // ⚠️ Si el código no es 200, lanza un error
        guard httpResponse.statusCode == 200 else {
            throw NSError(
                domain: "LoginError",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Login fallido. Código: \(httpResponse.statusCode)"]
            )
        }

        // ✅ Decodifica solo si el código fue exitoso
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        return loginResponse
    }

    
    
}
