import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isLoggedIn = false

    let authController = AuthenticationController(httpClient: HTTPClient())

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Text("Inicia Sesión")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)

                    VStack(spacing: 0) {
                        TextField("Correo", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Button(action: {
                            Task {
                                isLoading = true
                                do {
                                    let success = try await authController.loginUser(email: email, password: password)
                                    isLoading = false
                                    if success {
                                        isLoggedIn = true
                                    } else {
                                        alertMessage = "Credenciales incorrectas"
                                        showAlert = true
                                    }
                                } catch {
                                    isLoading = false
                                    alertMessage = "Error: \(error.localizedDescription)"
                                    showAlert = true
                                }
                            }
                        }) {
                            Text("Iniciar sesión")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                        }
                    }

                    Spacer()

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
                                // Acción de recuperación
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        }
                    }
                    .font(.caption)
                }
                .padding(30)

                // Navegación oculta a HomeView
                NavigationLink(destination: HomeView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Inicio de sesión fallido"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("¡Bienvenido a la app!")
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    LoginView()
}
