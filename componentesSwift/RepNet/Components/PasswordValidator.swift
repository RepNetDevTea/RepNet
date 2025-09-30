//
//  PasswordValidator.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import Foundation
import Combine

// El enum de requisitos se mueve aquí para ser accesible globalmente.
enum PasswordRequirement: String, CaseIterable {
    case minLength = "8 caracteres mínimo."
    case maxLength = "20 caracteres máximo."
    case hasUppercase = "1 letra mayúscula."
    case hasNumber = "1 número."
    case hasSpecialChar = "1 caracter especial (# ! % $)."
}

struct PasswordValidator {
    
    // Función pública y estática para que pueda ser llamada desde cualquier lugar.
    static func validate(password: String) -> [PasswordRequirement: ValidationState] {
        var states: [PasswordRequirement: ValidationState] = [:]

        if password.isEmpty {
            PasswordRequirement.allCases.forEach { states[$0] = .neutral }
            return states
        }
        
        states[.minLength] = password.count >= 8 ? .success : .failure
        states[.maxLength] = password.count <= 20 ? .success : .failure
        states[.hasUppercase] = password.rangeOfCharacter(from: .uppercaseLetters) != nil ? .success : .failure
        states[.hasNumber] = password.rangeOfCharacter(from: .decimalDigits) != nil ? .success : .failure
        states[.hasSpecialChar] = password.range(of: "[#!%$]", options: .regularExpression) != nil ? .success : .failure
        
        return states
    }
}
