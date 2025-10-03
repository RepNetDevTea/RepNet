//
//  SecureInputViewComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct SecureInputViewComponent: View {
    @Binding var text: String
    let placeholder: String
    var isError: Bool = false
    
    @State private var isPasswordVisible = false

    var body: some View {
        HStack {
            if isPasswordVisible {
                TextField(placeholder, text: $text)
            } else {
                SecureField(placeholder, text: $text)
            }

            Button(action: {
                isPasswordVisible.toggle()
            }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundColor(.textSecondary)
            }
        }
        .font(.bodyText)
        .foregroundColor(isError ? .errorRed : .textPrimary)
        .padding(15)
        .autocapitalization(.none)
    }
}
