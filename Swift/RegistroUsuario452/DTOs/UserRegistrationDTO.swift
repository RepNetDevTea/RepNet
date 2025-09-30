//
//  UserRegistrationDTO.swift
//  RegistroUsuario452
//
//  Created by José Molina on 29/08/25.
//

import Foundation

struct RegistrationFormRequest:Codable {
    var name: String
    var email: String
    var password: String
}

struct RegistrationFormResponse: Decodable {
        let id: Int
        let email, name, passwordHash, salt: String

        enum CodingKeys: String, CodingKey {
            case id, email, name
            case passwordHash = "password_hash"
            case salt
        }
    }
    

