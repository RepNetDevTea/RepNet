//
//  LoginView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    // Inyectamos el AuthenticationManager desde el entorno para poder
    // pasárselo a la función de login.
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
                    InputViewComponent(text: $viewModel.email, placeholder: "Correo", isError: viewModel.errorMessage != nil)
                    Divider().padding(.horizontal)
                    SecureInputViewComponent(text: $viewModel.password, placeholder: "Contraseña", isError: viewModel.errorMessage != nil)
                }
                .background(Color.textFieldBackground)
                .cornerRadius(16)
                
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(errorMessage)
                        Spacer()
                    }
                    .foregroundColor(.errorRed).font(.caption).padding(.leading)
                }
                
                // --- PUNTO CLAVE ---
                // Esta es la implementación final y correcta del botón.
                PrimaryButtonComponent(
                    title: "Iniciar sesión",
                    action: {
                        // Para llamar a una función 'async' (que espera en la red),
                        // la acción debe estar envuelta en un 'Task'.
                        // Esto ejecuta la llamada a la API en segundo plano sin congelar la app.
                        Task {
                            await viewModel.login(with: authManager)
                        }
                    },
                    isEnabled: viewModel.isFormValid
                )
                
                Spacer()

                VStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?").foregroundColor(.textSecondary)
                        NavigationLink("Regístrate", destination: SignUpView())
                            .foregroundColor(.textLink).fontWeight(.bold)
                    }
                    HStack(spacing: 4) {
                        Text("¿Olvidaste tu contraseña?").foregroundColor(.textSecondary)
                        Button("Recupérala") {}.foregroundColor(.textLink).fontWeight(.bold)
                    }
                }
                .font(.caption)
            }
            .padding(30)
            
            // El overlay de carga se muestra cuando 'isLoading' es true.
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().scaleEffect(1.5).tint(.white)
            }
        }
        .navigationBarHidden(true)
    }
}

// La vista previa necesita el AuthenticationManager en su entorno para funcionar.
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
                .environmentObject(AuthenticationManager())
        }
    }
}

