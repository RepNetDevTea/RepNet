//
//  URLSettings.swift
//  RegistroUsuario452
//
//  Created by José Molina on 12/09/25.
//

import Foundation

struct URLSettings{
    static let server = "http://localhost:3000"
    static let register = String(server+"/users")
    static let login = "http://localhost:3000/auth/login"
}
