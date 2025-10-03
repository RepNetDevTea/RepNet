//
//  LoginRequestDTO.swift
//  RepNet
//
//  Created by Angel Bosquez on 01/10/25.
//

import Foundation

// El 'struct' que enviamos al backend. Coincide con el de tu amigo.
// Las propiedades deben llamarse 'email' y 'password' para que el JSON sea correcto.
struct LoginRequestDTO: Codable {
    let email: String
    let password: String
}

// El 'struct' que recibimos del backend. Es mucho más detallado y lo adaptamos.
// Las propiedades deben coincidir con las claves del JSON de respuesta (user, accessToken, etc.).
struct LoginResponseDTO: Decodable {
    let user: UserDTO
    let accessToken: String
    let refreshToken: String
}

// Un DTO para los datos del usuario que vienen en la respuesta del login.
// Solo incluimos los campos que nos interesan por ahora.
struct UserDTO: Decodable {
    let id: Int
    let name: String
    let fathersLastName: String
    let mothersLastName: String
    let username: String
    let email: String
}
