//
//  SignUpView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

// esta es la vista de swiftui para la pantalla de "registro".
// es un formulario grande cuya logica y validacion en tiempo real
// son manejadas por el `signupviewmodel`.

// -- componentes utilizados --
// - inputviewcomponent
// - secureinputviewcomponent
// - passwordrequirementcomponent
// - primarybuttoncomponent
struct SignUpView: View {
    
    // se crea la instancia del viewmodel que controla esta vista.
    @StateObject private var viewModel = SignUpViewModel()
    // se usa para poder cerrar/descartar esta pantalla (ej. para volver al login).
    @Environment(\.presentationMode) var presentationMode
    
    // nos dice si el usuario esta escribiendo en un campo de contrasena,
    // para saber cuando mostrar la lista de requisitos.
    @FocusState private var isPasswordEditing: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("crea tu cuenta")
                        .font(.largeTitle)
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    
                    // seccion con todos los campos del formulario.
                    VStack(spacing: 0) {
                        InputViewComponent(text: $viewModel.name, placeholder: "nombre")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.fathersLastName, placeholder: "apellido paterno")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.mothersLastName, placeholder: "apellido materno")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.username, placeholder: "nombre de usuario")
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.email, placeholder: "correo", isError: viewModel.emailErrorMessage != nil)
                        Divider().padding(.horizontal)
                        SecureInputViewComponent(text: $viewModel.password, placeholder: "contrasena").focused($isPasswordEditing)
                        Divider().padding(.horizontal)
                        SecureInputViewComponent(text: $viewModel.confirmPassword, placeholder: "confirma contrasena", isError: viewModel.passwordsMatch == .failure).focused($isPasswordEditing)
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    
                    // seccion para el error del email.
                    if let emailError = viewModel.emailErrorMessage {
                        Text(emailError).font(.caption).foregroundColor(.errorRed)
                    }
                    
                    // la lista de requisitos de contrasena solo aparece si el usuario
                    // tiene el cursor en uno de los campos de contrasena.
                    if isPasswordEditing {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(PasswordRequirement.allCases, id: \.self) { requirement in
                                PasswordRequirementComponent(requirement: requirement.rawValue, state: viewModel.passwordValidationStates[requirement] ?? .neutral)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // seccion para el error de contrasenas que no coinciden.
                    if let passwordError = viewModel.passwordErrorMessage {
                        Text(passwordError).font(.caption).foregroundColor(.errorRed)
                    }
                    
                    // el boton de crear cuenta.
                    PrimaryButtonComponent(
                        title: "crear cuenta",
                        action: {
                            // se envuelve la llamada `async` en un `task`.
                            Task {
                                await viewModel.signUp()
                            }
                        },
                        // el boton solo se activa si el formulario es valido.
                        isEnabled: viewModel.isFormValid
                    )
                    
                    Spacer()

                    // seccion inferior con el boton para regresar al login.
                    HStack(spacing: 4) {
                        Text("¿ya tienes cuenta?").foregroundColor(.textSecondary)
                        Button("inicia sesion") { presentationMode.wrappedValue.dismiss() }
                            .foregroundColor(.textLink).fontWeight(.bold)
                    }
                    .font(.caption)
                }
                .padding(30)
                .animation(.easeInOut, value: isPasswordEditing)
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .disabled(viewModel.isLoading) // deshabilita el formulario mientras carga.
            // alerta de exito que se muestra cuando el registro es exitoso.
            // al presionar "ok", se cierra esta pantalla.
            .alert("registro exitoso", isPresented: $viewModel.registrationSuccessful) {
                Button("ok", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("tu cuenta ha sido creada. ahora puedes iniciar sesion.")
            }
            
            // overlay de carga que se muestra si `isloading` es `true`.
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
