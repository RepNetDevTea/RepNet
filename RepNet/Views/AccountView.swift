//
//  AccountView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct AccountView: View {
    
    @StateObject private var viewModel = AccountViewModel()
    @EnvironmentObject var authManager: AuthenticationManager
    @FocusState private var isPasswordEditing: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color.appBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // --- CAMBIO #1: Se ha añadido un campo para mostrar errores ---
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.errorRed)
                            .font(.caption)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.errorRed.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // --- CAMBIO #2: Se han corregido los campos de apellidos ---
                    VStack(spacing: 0) {
                        InputViewComponent(text: $viewModel.name, placeholder: "Nombre").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        // Corregido para usar 'fathersLastName' y 'mothersLastName' como en el ViewModel.
                        InputViewComponent(text: $viewModel.fathersLastName, placeholder: "Apellido Paterno").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.mothersLastName, placeholder: "Apellido Materno").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.username, placeholder: "Nombre de Usuario").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.email, placeholder: "Correo").disabled(!viewModel.isEditing)
                        
                        if viewModel.isEditing {
                            VStack {
                                Divider().padding(.horizontal)
                                // --- CAMBIO #3: Se ha añadido el campo de contraseña actual ---
                                // Este campo es crucial para autorizar los cambios en el backend.
                                SecureInputViewComponent(text: $viewModel.currentPassword, placeholder: "Contraseña actual para autorizar")
                                    .focused($isPasswordEditing)
                                Divider().padding(.horizontal)
                                SecureInputViewComponent(text: $viewModel.newPassword, placeholder: "Nueva contraseña (opcional)")
                                    .focused($isPasswordEditing)
                                Divider().padding(.horizontal)
                                SecureInputViewComponent(text: $viewModel.confirmPassword, placeholder: "Confirmar contraseña", isError: viewModel.passwordsMatch == .failure)
                                    .focused($isPasswordEditing)
                            }
                            .transition(.opacity)
                        }
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                    
                    // Muestra los requisitos de la contraseña si se está editando
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
                    
                    // Botones de acción (sin cambios)
                    VStack {
                        NavigationLink(destination: AppInfoView()) {
                            ListItem(title: "App info", icon: "info.circle")
                        }
                        ListItem(title: "Cerrar sesión", icon: "rectangle.portrait.and.arrow.right", action: { viewModel.showLogoutAlert = true })
                        ListItem(title: "Eliminar mi cuenta", icon: "trash", color: .errorRed, action: { viewModel.showDeleteAlert = true })
                    }
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                }
                .padding()
            }
            .disabled(viewModel.isLoading) // Deshabilita la vista mientras carga
            
            // Muestra el banner de éxito
            if viewModel.showSuccessBanner {
                SuccessBannerComponent(message: "Cambios guardados exitosamente")
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            // Muestra el indicador de carga
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().scaleEffect(1.5).tint(.white)
            }
        }
        .navigationTitle("Mi cuenta")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(viewModel.isEditing ? "Guardar" : "Editar") {
                    if viewModel.isEditing {
                        // --- CAMBIO #4: La llamada a guardar ahora está en un Task ---
                        Task {
                            await viewModel.saveChanges()
                        }
                    } else {
                        viewModel.isEditing.toggle()
                    }
                }
                .fontWeight(.bold)
                .disabled(viewModel.isEditing && !viewModel.isFormValid)
                .tint(.primaryBlue)
            }
        }
        // --- CAMBIO #5: Llama a la API cuando la vista aparece ---
        .onAppear {
            Task {
                await viewModel.fetchUserProfile()
            }
        }
        .animation(.easeInOut, value: viewModel.isEditing)
        .animation(.easeInOut, value: viewModel.showSuccessBanner)
        .animation(.easeInOut, value: isPasswordEditing)
        .alert("Cerrar sesión", isPresented: $viewModel.showLogoutAlert) {
            Button("No", role: .cancel) {}
            Button("Sí", role: .destructive) { authManager.logout() }
        } message: { Text("¿Seguro que quieres salir?") }
        .alert("Eliminar mi cuenta", isPresented: $viewModel.showDeleteAlert) {
            Button("No", role: .cancel) {}
            Button("Sí", role: .destructive) { authManager.logout() }
        } message: { Text("¿Seguro que quieres eliminarla? Esta acción es permanente y no podrás volver a acceder.") }
    }
}


// El componente ListItem y la Vista Previa se mantienen igual
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

