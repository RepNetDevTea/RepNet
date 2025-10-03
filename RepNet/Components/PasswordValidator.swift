//
//  PasswordValidator.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import Foundation
import SwiftUI // <-- LA SOLUCIÓN ESTÁ AQUÍ

// Al importar SwiftUI, este archivo ahora tiene acceso al tipo 'Color'
// y a nuestras extensiones de color personalizadas (como .textSecondary).

enum ValidationState {
    case neutral
    case success
    case failure

    var iconName: String {
        switch self {
        case .neutral: return "circle"
        case .success: return "checkmark.circle.fill"
        case .failure: return "xmark.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .neutral: return .textSecondary
        case .success: return .green
        case .failure: return .errorRed
        }
    }
}

enum PasswordRequirement: String, CaseIterable {
    case minLength = "8 caracteres mínimo."
    case maxLength = "20 caracteres máximo."
    case hasUppercase = "1 letra mayúscula."
    case hasNumber = "1 número."
    case hasSpecialChar = "1 caracter especial (!@#$%^&*?)."
}

struct PasswordValidator {
    static func validate(password: String) -> [PasswordRequirement: ValidationState] {
        var states: [PasswordRequirement: ValidationState] = [:]

        if password.isEmpty {
            PasswordRequirement.allCases.forEach { states[$0] = .neutral }
            return states
        }
        
        states[.minLength] = password.tieneLongitudMinima ? .success : .failure
        states[.maxLength] = password.tieneLongitudMaxima ? .success : .failure
        states[.hasUppercase] = password.tieneMayuscula ? .success : .failure
        states[.hasNumber] = password.tieneNumero ? .success : .failure
        states[.hasSpecialChar] = password.tieneCaracterEspecial ? .success : .failure
        
        return states
    }
}
