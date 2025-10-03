//
//  UsersDTO.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//
//Nota para Emi: este tiene pedos con el JWTauthguard, como tal si se conecta pero no lo deja pasar
import Foundation

// Este DTO representa los datos del perfil de usuario que recibimos del backend.
// Este struct se mantiene sin cambios, ya que sigue representando los datos que nos llegan.
struct UserProfileResponseDTO: Decodable {
    let name: String
    let fathersLastName: String
    let mothersLastName: String
    let email: String
    let username: String
}

// --- ARCHIVO ACTUALIZADO ---
// Este DTO representa los datos que enviaremos para actualizar el perfil.
// Ha sido modificado para incluir todos los campos y la lógica de autorización.
struct UpdateProfileRequestDTO: Encodable {
    
    // --- Campos de Datos del Usuario (Opcionales) ---
    // El usuario puede enviar solo los campos que desea cambiar.
    let name: String?
    let fathersLastName: String?
    let mothersLastName: String?
    let username: String?
    let email: String?
    
    // --- Campo de Autorización (Requerido) ---
    // La contraseña actual del usuario, necesaria para autorizar cualquier cambio.
    let currentPassword: String
    
    // --- Campo para Cambiar Contraseña (Opcional) ---
    // Si el usuario quiere cambiar su contraseña, enviará el nuevo valor aquí.
    // Si no, este campo puede ser 'nil'.
    let newPassword: String?
}
