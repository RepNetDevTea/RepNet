//
//  RepNetApp.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

@main
struct RepNetApp: App {
    
    @StateObject private var authManager = AuthenticationManager()
    
    
    var body: some Scene {
            WindowGroup {
                // La vista que se muestra depende del estado de autenticación.
                if authManager.isAuthenticated {
                    // Si está autenticado, muestra la vista principal con las pestañas.
                    MainTabView()
                        .environmentObject(authManager) // Inyectamos el gestor en el entorno.
                } else {
                    // Si no, muestra la vista de Login.
                    // Ya no necesitamos la LaunchView, la lógica de login se encarga.
                    NavigationView {
                        LoginView()
                            .environmentObject(authManager) // También lo inyectamos aquí.
                    }
                }
            }
        }
    }
