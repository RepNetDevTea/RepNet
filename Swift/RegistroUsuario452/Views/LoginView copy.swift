//
//  LoginView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea() // Simula el color de fondo

            VStack(spacing: 20) {
                Spacer()
                
                Text("Inicia Sesión")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                VStack(spacing: 0) {
                    TextField("Correo", text: $email)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(16)
                    
                    Divider().padding(.horizontal)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(16)
                }
                .background(Color(.systemGray5))
                .cornerRadius(16)

                // Botón simplificado para el login
                Button(action: {
                    // Simula la acción de login para prueba
                    print("Intentando login con: \(email) y \(password)")
                }) {
                    Text("Iniciar sesión")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }

                Spacer()
                
                // Enlaces de registro y recuperación
                VStack(spacing: 15) {
                    HStack(spacing: 4) {
                        Text("¿No tienes cuenta?")
                        Text("Regístrate")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 4) {
                        Text("¿Olvidaste tu contraseña?")
                        Button("Recupérala") {
                            // Acción de recuperación de a (no hace nada)
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    }
                }
                .font(.caption)
            }
            .padding(30)
        }
    }
}

#Preview {
    NavigationView {
        LoginView()
    }
}
