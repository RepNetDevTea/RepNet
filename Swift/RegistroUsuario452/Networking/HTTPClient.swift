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
    
    func UserLogin(email:String, password:String) async throws -> LoginResponse{
        let loginRequest = LoginRequest(email:email, password:password)
        //let url = URL(string: "http://localhost:3000/auth/login")!
        guard let url = URL(string: "http://localhost:3000/auth/login") else {
            fatalError("Invalid URL" + "http://localhost:3000/auth/login")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(loginRequest)
        let (data, response) = try await URLSession.shared.data(for:urlRequest)
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        return loginResponse
    }
    
    
}
