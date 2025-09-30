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
                    
                    VStack(spacing: 0) {
                        InputViewComponent(text: $viewModel.name, placeholder: "Nombre").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.lastName, placeholder: "Apellidos").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text:$viewModel.username, placeholder: "Nombre de Usuario").disabled(!viewModel.isEditing)
                        Divider().padding(.horizontal)
                        InputViewComponent(text: $viewModel.email, placeholder: "Correo").disabled(!viewModel.isEditing)
                        
                        if viewModel.isEditing {
                            VStack {
                                Divider().padding(.horizontal)
                                SecureInputViewComponent(text: $viewModel.newPassword, placeholder: "Nueva contraseña")
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
            
            if viewModel.showSuccessBanner {
                SuccessBannerComponent(message: "Cambios guardados exitosamente")
                    .padding(.horizontal)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Mi cuenta")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(viewModel.isEditing ? "Guardar" : "Editar") {
                    if viewModel.isEditing {
                        viewModel.saveChanges()
                    } else {
                        viewModel.isEditing.toggle()
                    }
                }
                .fontWeight(.bold)
                .disabled(viewModel.isEditing && !viewModel.isFormValid)
                .tint(.primaryBlue)
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
