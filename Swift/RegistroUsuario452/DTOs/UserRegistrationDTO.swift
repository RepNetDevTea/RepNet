//
//  UserRegistrationDTO.swift
//  RegistroUsuario452
//
//  Created by José Molina on 29/08/25.
//

import Foundation

struct RegistrationFormRequest:Codable {
    var name: String
    var fatherLastName: String
    var motherLastName: String
    var userName: String
    var email: String
    var password: String
}

struct RegistrationFormResponse: Decodable {
    let newUser: UserRegistrationWay
    let accesToken: String
    let refreshToken: String
    
        
}
    
struct UserRegistrationWay: Decodable {
    let id: Int
    let name, fatherLastName, motherLastName, userName, email, hashedPassword, hashedRefreshToken,userStatus, userRole , updatedAt, createdAt: String
}

