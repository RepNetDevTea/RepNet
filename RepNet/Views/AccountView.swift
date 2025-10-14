//
//  AccountView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

// esta es la vista de swiftui para la pantalla de "mi cuenta".
// toda la informacion que muestra y las acciones que ejecuta vienen del `accountviewmodel`.

// -- componentes utilizados --
// - inputviewcomponent
// - secureinputviewcomponent
// - passwordrequirementcomponent
// - successbannercomponent
// - listitem (vista auxiliar local)
struct AccountView: View {
    
    // se crea una instancia del viewmodel. `@stateobject` asegura que viva mientras la vista exista.
    @StateObject private var viewModel = AccountViewModel()
    // se obtiene el `authmanager` del entorno para poder realizar acciones globales como cerrar sesion.
    @EnvironmentObject var authManager: AuthenticationManager
    // `@focusstate` nos ayuda a saber si el usuario esta escribiendo en los campos de contrasena.
    @FocusState private var isPasswordEditing: Bool

    var body: some View {
        // la vista principal es un `zstack` para poder poner overlays (banner de exito, indicador de carga).
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // se muestra solo si hay un mensaje de error en el viewmodel.
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.errorRed)
                            .font(.caption)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.errorRed.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // seccion con los campos de informacion del usuario.
                    VStack(spacing: 0) {
                        // cada campo se conecta al viewmodel con `$` (binding).
                        // se desactivan si no se esta en modo de edicion.
                        InputViewComponent(text: $viewModel.name, placeholder: "nombre").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.fathersLastName, placeholder: "apellido paterno").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.mothersLastName, placeholder: "apellido materno").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.username, placeholder: "nombre de usuario").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.email, placeholder: "correo").disabled(!viewModel.isEditing)
                        
                        // los campos para cambiar la contrasena solo aparecen en modo de edicion.
                        if viewModel.isEditing {
                            VStack {
                                Divider().padding(.horizontal)
                                SecureInputViewComponent(text: $viewModel.currentPassword, placeholder: "contrasena actual para autorizar")
                                    .focused($isPasswordEditing) // se conecta al focusstate.
                                Divider().padding(.horizontal)
                                SecureInputViewComponent(text: $viewModel.newPassword, placeholder: "nueva contrasena (opcional)")
                                    .focused($isPasswordEditing)
                                Divider().padding(.horizontal)
                                SecureInputViewComponent(text: $viewModel.confirmPassword, placeholder: "confirmar contrasena", isError: viewModel.passwordsMatch == .failure)
                                    .focused($isPasswordEditing)
                            }
                            .transition(.opacity)
                        }
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    
                    // la lista de requisitos de contrasena solo aparece si se esta editando
                    // y el usuario tiene el teclado activo en uno de los campos de contrasena.
                    if viewModel.isEditing && isPasswordEditing {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(PasswordRequirement.allCases, id: \.self) { requirement in
                                PasswordRequirementComponent(
                                    requirement: requirement.rawValue,
                                    state: viewModel.passwordValidationStates[requirement] ?? .neutral
                                )
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // seccion con los botones de accion (info, cerrar sesion, etc.).
                    VStack {
                        NavigationLink(destination: AppInfoView()) {
                            ListItem(title: "app info", icon: "info.circle")
                        }
                        ListItem(title: "cerrar sesion", icon: "rectangle.portrait.and.arrow.right", action: { viewModel.showLogoutAlert = true })
                        ListItem(title: "eliminar mi cuenta", icon: "trash", color: .errorRed, action: { viewModel.showDeleteAlert = true })
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                }
                .padding()
            }
            .disabled(viewModel.isLoading) // se deshabilita toda la vista mientras se carga.
            
            // --- overlays ---
            
            // muestra el banner de exito si `showsuccessbanner` es true en el viewmodel.
            if viewModel.showSuccessBanner {
                SuccessBannerComponent(message: "cambios guardados exitosamente")
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // muestra el indicador de carga si `isloading` es true en el viewmodel.
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().scaleEffect(1.5).tint(.white)
            }
        }
        .navigationTitle("mi cuenta")
        .toolbar {
            // el boton de la barra de navegacion cambia entre "editar" y "guardar"
            // y se activa/desactiva segun el estado del viewmodel.
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(viewModel.isEditing ? "guardar" : "editar") {
                    if viewModel.isEditing {
                        Task { await viewModel.saveChanges() }
                    } else {
                        viewModel.isEditing.toggle()
                    }
                }
                .fontWeight(.bold)
                .disabled(viewModel.isEditing && !viewModel.isFormValid)
                .tint(.primaryBlue)
            }
        }
        .onAppear {
            // cuando la vista aparece por primera vez, le pide al viewmodel que cargue los datos del perfil.
            Task {
                await viewModel.fetchUserProfile()
            }
        }
        .animation(.easeInOut, value: viewModel.isEditing)
        .animation(.easeInOut, value: viewModel.showSuccessBanner)
        .animation(.easeInOut, value: isPasswordEditing)
        // las alertas tambien se controlan con booleanos del viewmodel.
        // la accion de cerrar sesion se delega al `authmanager`.
        .alert("cerrar sesion", isPresented: $viewModel.showLogoutAlert) {
            Button("no", role: .cancel) {}
            Button("si", role: .destructive) { authManager.logout() }
        } message: { Text("¿seguro que quieres salir?") }
        .alert("eliminar mi cuenta", isPresented: $viewModel.showDeleteAlert) {
            Button("no", role: .cancel) {}
            Button("si", role: .destructive) { authManager.logout() }
        } message: { Text("¿seguro que quieres eliminarla? esta accion es permanente y no podras volver a acceder.") }
    }
}


// un componente de vista auxiliar y reutilizable para los items de la lista de acciones.
struct ListItem: View {
    let title: String
    let icon: String
    var color: Color = .textPrimary
    var action: (() -> Void)? = nil

    var body: some View {
        if let action = action {
            Button(action: action) {
                HStack {
                    Text(title).foregroundColor(color)
                    Spacer()
                    Image(systemName: icon).foregroundColor(color)
                }
                .padding()
            }
        } else {
            HStack {
                Text(title).foregroundColor(color)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.textSecondary)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationView {
        AccountView()
            .environmentObject(AuthenticationManager())
    }
}
