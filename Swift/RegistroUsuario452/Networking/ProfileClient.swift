//
//  ProfileClient.swift
//  RegistroUsuario452
//
//  Created by José Molina on 12/09/25.
//
import Foundation

class ProfileClient{
    
    func getUserProfile(token:String) async throws -> UserProfileResponse{
        guard let url = URL(string: "http://localhost:3000/auth/profile") else {
            fatalError("Invalid URL" + "http://localhost:3000/auth/profile")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for:urlRequest)
        let userProfileResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
        return userProfileResponse
    }
}
