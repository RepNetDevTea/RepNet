//
//  AppConfig.swift
// Igual a URLSettings pero con otro nombre
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//

import Foundation

// Usamos la estructura de tu amigo, que es muy clara.
struct AppConfig {
    // La dirección IP de tu servidor local.
    static let server = "http://10.48.200.102:3000"
    
    // --- Endpoints de Autenticación ---
    static let loginURL = server + "/auth/login"
    static let registerURL = server + "/users"
    
    // --- NUEVO ENDPOINT PARA EL PERFIL DE USUARIO ---
    // Asumiremos que el endpoint para obtener/modificar el perfil
    // del usuario actual es "/users/me". ¡Confirma esto con tu backend!
    static let userProfileURL = server + "/users/me"
}

