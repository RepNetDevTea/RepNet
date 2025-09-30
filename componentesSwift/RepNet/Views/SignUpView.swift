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
    
    //sirve para abrir requisitos de contrasena cuando se haga clikc
    @FocusState private var isPasswordEditing: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Crea tu cuenta")
                    .font(.largeTitle)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
                //--- card del frmulario ---
                VStack(spacing: 0) {
                    InputViewComponent(text: $viewModel.name, placeholder: "Nombre")
                    Divider().padding(.horizontal)
                    InputViewComponent(text: $viewModel.lastName, placeholder: "Apellidos")
                    Divider().padding(.horizontal)
                    InputViewComponent(text: $viewModel.username, placeholder: "Nombre de usuario")
                    Divider().padding(.horizontal)
                    InputViewComponent(
                        text: $viewModel.email,
                        placeholder: "Correo",
                        isError: viewModel.isEmailValid == .failure
                    )
                    Divider().padding(.horizontal)
                    SecureInputViewComponent(
                        text: $viewModel.password,
                        placeholder: "Contraseña"
                    )
                    //rastreo de foco
                    .focused($isPasswordEditing)
                    Divider().padding(.horizontal)
                    SecureInputViewComponent(
                        text: $viewModel.confirmPassword,
                        placeholder: "Confirma contraseña",
                        isError: viewModel.passwordsMatch == .failure
                    )
                    .focused($isPasswordEditing)
                }
                .background(Color.textFieldBackground)
                .cornerRadius(16)
                
                // --- mensajed e error ---
                if let emailError = viewModel.emailErrorMessage {
                    Text(emailError).font(.caption).foregroundColor(.errorRed)
                }
                
                // --- requisitos de contrasnea ---
                if isPasswordEditing {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(SignUpViewModel.PasswordRequirement.allCases, id: \.self) { requirement in
                            PasswordRequirementComponent(
                                requirement: requirement.rawValue,
                                state: viewModel.passwordValidationStates[requirement] ?? .neutral
                            )
                        }
                    }
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                if let passwordError = viewModel.passwordErrorMessage {
                    Text(passwordError).font(.caption).foregroundColor(.errorRed)
                }
                
                // --- boton para crear cuenta ---
                PrimaryButtonComponent(
                    title: "Crear cuenta",
                    action: viewModel.signUp,
                    isEnabled: viewModel.isFormValid
                )
                
                Spacer()

                // --- enlace inferior para regresar a login ---
                HStack(spacing: 4) {
                    Text("¿Ya tienes cuenta?")
                        .foregroundColor(.textSecondary)
                    Button("Inicia Sesión") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.textLink)
                    .fontWeight(.bold)
                }
                .font(.caption)
            }
            .padding(30)
            .animation(.easeInOut, value: isPasswordEditing) //animacion para requisitos
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

#Preview {
    SignUpView()
}
