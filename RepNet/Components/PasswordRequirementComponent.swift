//
//  PasswordRequirementComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

// --- CAMBIO IMPORTANTE ---
// Se ha eliminado por completo el 'enum ValidationState' de este archivo.
// El componente ahora es más simple y simplemente utiliza el 'ValidationState'
// global que definimos en el archivo 'Utils/PasswordValidator.swift'.
// No necesita definirlo él mismo.

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


struct PasswordRequirementComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 10) {
            PasswordRequirementComponent(requirement: "8 caracteres mínimo.", state: .neutral)
            PasswordRequirementComponent(requirement: "1 caracter especial (!@#$%^&*?).", state: .success)
            PasswordRequirementComponent(requirement: "1 caracter numérico (1 2 3 4).", state: .failure)
        }
        .padding()
    }
}
