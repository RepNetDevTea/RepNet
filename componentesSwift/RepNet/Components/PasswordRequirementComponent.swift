//
//  PasswordRequirementComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

// Este enum nos ayudará a manejar los diferentes estados de validación
enum ValidationState {
    case neutral     // Aún no se evalúa (círculo gris)
    case success     // Requisito cumplido (tilde verde)
    case failure     // Requisito no cumplido (cruz roja)

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

struct PasswordRequirementComponent: View {
    let requirement: String
    let state: ValidationState

    var body: some View {
        HStack {
            Image(systemName: state.iconName)
            Text(requirement)
            Spacer()
        }
        .font(.caption)
        .foregroundColor(state.color)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        PasswordRequirementComponent(requirement: "8 caracteres mínimo.", state: .neutral)
        PasswordRequirementComponent(requirement: "1 caracter especial (# ! % $).", state: .success)
        PasswordRequirementComponent(requirement: "1 caracter numérico (1 2 3 4).", state: .failure)
    }
    .padding()
}
