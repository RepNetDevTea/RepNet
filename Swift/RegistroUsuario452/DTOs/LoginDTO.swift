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
    let newUser: UserLoginWay
    let accessToken: String
    let refreshToken: String
}
    
struct UserLoginWay: Decodable {
    let id: Int
    let userName, email, userRole , userStatus: String
}

