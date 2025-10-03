//
//  SignUpView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isPasswordEditing: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Crea tu cuenta")
                        .font(.largeTitle)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 0) {
                        InputViewComponent(text: $viewModel.name, placeholder: "Nombre")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.fathersLastName, placeholder: "Apellido Paterno")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.mothersLastName, placeholder: "Apellido Materno")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.username, placeholder: "Nombre de usuario")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.email, placeholder: "Correo", isError: viewModel.emailErrorMessage != nil)
                        Divider().padding(.horizontal)
                        SecureInputViewComponent(text: $viewModel.password, placeholder: "Contraseña").focused($isPasswordEditing)
                        Divider().padding(.horizontal)
                        SecureInputViewComponent(text: $viewModel.confirmPassword, placeholder: "Confirma contraseña", isError: viewModel.passwordsMatch == .failure).focused($isPasswordEditing)
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    
                    if let emailError = viewModel.emailErrorMessage {
                        Text(emailError).font(.caption).foregroundColor(.errorRed)
                    }
                    
                    if isPasswordEditing {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(PasswordRequirement.allCases, id: \.self) { requirement in
                                PasswordRequirementComponent(requirement: requirement.rawValue, state: viewModel.passwordValidationStates[requirement] ?? .neutral)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    if let passwordError = viewModel.passwordErrorMessage {
                        Text(passwordError).font(.caption).foregroundColor(.errorRed)
                    }
                    
                    // --- CAMBIO AQUÍ: La acción del botón ahora está en un Task ---
                    PrimaryButtonComponent(
                        title: "Crear cuenta",
                        action: {
                            Task {
                                await viewModel.signUp()
                            }
                        },
                        isEnabled: viewModel.isFormValid
                    )
                    
                    Spacer()

                    HStack(spacing: 4) {
                        Text("¿Ya tienes cuenta?").foregroundColor(.textSecondary)
                        Button("Inicia Sesión") { presentationMode.wrappedValue.dismiss() }
                            .foregroundColor(.textLink).fontWeight(.bold)
                    }
                    .font(.caption)
                }
                .padding(30)
                .animation(.easeInOut, value: isPasswordEditing)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            // --- CAMBIO AQUÍ: Overlay de Carga ---
            .disabled(viewModel.isLoading) // Deshabilita el formulario mientras carga
            
            // --- CAMBIO AQUÍ: Alerta de Éxito ---
            .alert("Registro Exitoso", isPresented: $viewModel.registrationSuccessful) {
                Button("OK", role: .cancel) {
                    // Al presionar OK, cierra la pantalla de registro
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Tu cuenta ha sido creada. Ahora puedes iniciar sesión.")
            }
            
            // Muestra el indicador de carga
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().scaleEffect(1.5).tint(.white)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
