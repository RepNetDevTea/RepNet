//
//  InputViewComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

struct InputViewComponent: View {
    @Binding var text: String
    let placeholder: String
    var isError: Bool = false

    var body: some View {
        TextField(placeholder, text: $text)
            .font(.bodyText)
            .foregroundColor(isError ? .errorRed : .textPrimary)
            .padding(15)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
    }
}

#Preview {
    //Binding creado con IA para ver cambios en tiempo real
    struct PreviewWrapper: View {
        @State var textNormal = ""
        @State var textError = "texto incorrecto"
        
        var body: some View {
            VStack(spacing: 20) {
                InputViewComponent(
                    text: $textNormal,
                    placeholder: "Campo de texto normal"
                )
                
                InputViewComponent(
                    text: $textError,
                    placeholder: "Campo con error",
                    isError: true
                )
            }
            .padding()
            //simula fondo de cards
            .background(Color.white)
        }
    }
    
    return PreviewWrapper()
}
