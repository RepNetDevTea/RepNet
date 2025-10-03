//
//  SignUpDTO.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let name: String
    let fathersLastName: String
    let mothersLastName: String
    let username: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case name, fathersLastName, mothersLastName, username, email
        case password = "hashedPassword"
    }
}
