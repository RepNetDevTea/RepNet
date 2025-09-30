//
//  PrimaryButtonComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct PrimaryButtonComponent: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.buttonFont)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? Color.primaryBlue : Color.disabledGray)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButtonComponent(title: "Botón Activado", action: {}, isEnabled: true)
        PrimaryButtonComponent(title: "Botón Desactivado", action: {}, isEnabled: false)
    }
    .padding()
}
