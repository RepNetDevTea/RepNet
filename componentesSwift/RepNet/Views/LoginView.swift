//
//  LoginView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()
                
                Text("Inicia Sesión")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                VStack(spacing: 0) {
                    InputViewComponent(
                        text: $viewModel.email,
                        placeholder: "Correo",
                        isError: viewModel.errorMessage != nil
                    )
                    
                    Divider().padding(.horizontal)
                    
                    SecureInputViewComponent(
                        text: $viewModel.password,
                        placeholder: "Contraseña",
                        isError: viewModel.errorMessage != nil
                    )
                }
                .background(Color.textFieldBackground)
                .cornerRadius(16)
                
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(errorMessage)
                        Spacer()
                    }
                    .foregroundColor(.errorRed)
                    .font(.caption)
                    .padding(.leading)
                }
                
                PrimaryButtonComponent(
                    title: "Iniciar sesión",
                    action: {
                            viewModel.login(with: authManager) //aqui estaria el auticacion en backend supomgo
                        },
                        isEnabled: viewModel.isFormValid
                )
                
                Spacer()

                VStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                            .foregroundColor(.textSecondary)
                        NavigationLink("Regístrate", destination: SignUpView())
                    }
                    
                    HStack(spacing: 4) {
                        Text("¿Olvidaste tu contraseña?")
                            .foregroundColor(.textSecondary)
                        Button("Recupérala") {
                            // recupera contrasena no hace nada
                        }
                        .foregroundColor(.textLink)
                        .fontWeight(.bold)
                    }
                }
                .font(.caption)
            }
            .padding(30)
            
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationView {
        LoginView()
    }
}
