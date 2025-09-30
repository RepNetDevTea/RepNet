//
//  LoginDTO.swift
//  RegistroUsuario452
//
//  Created by José Molina on 05/09/25.
//

import Foundation

struct LoginRequest:Codable {
    var email:String
    var password:String
}

struct LoginResponse: Decodable {
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
