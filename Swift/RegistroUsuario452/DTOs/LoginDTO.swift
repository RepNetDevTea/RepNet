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
    let user: UserLoginWay
    let accessToken: String
    let refreshToken: String
}

struct UserLoginWay: Decodable {
    let id: Int
    let name: String
    let fathersLastName: String
    let mothersLastName: String
    let username: String
    let email: String
    let hashedPassword: String
    let hashedRefreshToken: String
    let userStatus: String
    let userRole: String
    let updatedAt: String
    let createdAt: String
}


