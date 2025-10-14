//
//  ReportDTOs.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//
// este archivo define los dtos para crear y recibir reportes de la api.

import Foundation

// este es el objeto que la app *envia* al backend para crear un nuevo reporte.
// `encodable` significa que se puede convertir a json.
struct CreateReportRequestDTO: Encodable {
    let reportTitle: String
    let reportUrl: String
    let reportDescription: String
    let siteDomain: String
    let tags: [String]
    let impacts: [String]
}

// este es el objeto que la app *recibe* del backend, representando un reporte completo.
// `decodable` significa que se puede crear a partir de un json.
// `identifiable` es para que swiftui pueda usarlo en listas y saber cual es cual.

struct ReportResponseDTO: Decodable, Identifiable {
    let id: Int
    let reportTitle: String
    let reportUrl: String
    let reportDescription: String
    let reportStatus: String
    let severity: Int
    let createdAt: String
    let site: SiteDTO?
    let user: UserInReportDTO?
    let tags: [TagDTO]
    let voteScore: Int?
    let userVoteStatus: UserVoteStatus?
}

// representa el sitio asociado a un reporte.
struct SiteDTO: Decodable { let siteDomain: String }
// representa al usuario que creo el reporte.
struct UserInReportDTO: Decodable { let username: String }
// representa tag del reporte
struct TagDTO: Decodable { let tagName: String }
