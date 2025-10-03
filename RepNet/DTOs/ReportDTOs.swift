//
//  ReportDTOs.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//

import Foundation

// --- DTO para ENVIAR un nuevo reporte ---
// Representa el JSON que el backend espera al crear un reporte.
struct CreateReportRequestDTO: Encodable {
    let reportTitle: String
    let reportUrl: String
    let reportDescription: String
    let severity: Int // El backend espera un número (0, 1, 2...)
    let siteDomain: String // El dominio del sitio asociado
    let tags: [String] // Nombres de los tags/categorías
    let impacts: [String] // Nombres de los impactos
}


// --- DTO para RECIBIR un reporte ---
// Representa el JSON que el backend nos devuelve para un reporte existente.
struct ReportResponseDTO: Decodable, Identifiable {
    let id: Int
    let reportTitle: String
    let reportUrl: String
    let reportDescription: String
    let reportStatus: String
    let severity: Int
    let createdAt: String
    let site: SiteDTO
    let user: UserInReportDTO
    let tags: [TagDTO]
}

// Sub-DTOs que vienen dentro de la respuesta de un reporte.
struct SiteDTO: Decodable {
    let siteDomain: String
}

struct UserInReportDTO: Decodable {
    let username: String
}

struct TagDTO: Decodable {
    let tagName: String
}
