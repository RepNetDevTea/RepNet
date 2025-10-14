//
//  Report.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//
// edefine el modelo `report`, la estructura de datos principal
// que la aplicacion usa para manejar y mostrar la informacion de un reporte en la ui.

// representa los dos estados posibles del voto de un usuario en un reporte.
// `codable` permite que se lea y escriba facilmente desde/hacia json.

import Foundation
import SwiftUI

enum UserVoteStatus: String, Codable {
    case upvoted
    case downvoted
}

// el modelo `report` que se usa en toda la ui.
// `identifiable` para que swiftui lo pueda usar en listas.
// `equatable` para poder comparar dos reportes (ej. `report1 == report2`)

struct Report: Identifiable, Equatable {
    static func == (lhs: Report, rhs: Report) -> Bool {
        //comparacion de reportes solo con id
        lhs.id == rhs.id
    }
    
    let id: UUID            // id unico en el cliente
    let displayId: String
    let title: String
    let date: String // fecha formateada
    let url: String
    let description: String
    let category: String
    let severity: String
    let user: UserInReportDTO
    
    // la fecha real, sin formatear. se usa internamente para ordenar los reportes
    let createdAt: Date
    
    //propiedades opcionales
    
    let statusText: String?
    let statusColor: Color?
    let voteScore: Int?
    let userVoteStatus: UserVoteStatus?
    
    // el inicializador para crear un nuevo objeto `report`.
    
    init(id: UUID = UUID(), displayId: String, title: String, date: String, url: String, description: String, category: String, severity: String, user: UserInReportDTO, createdAt: Date, statusText: String? = nil, statusColor: Color? = nil, voteScore: Int? = nil, userVoteStatus: UserVoteStatus? = nil) {
        self.id = id; self.displayId = displayId; self.title = title; self.date = date; self.url = url; self.description = description; self.category = category; self.severity = severity; self.user = user; self.createdAt = createdAt; self.statusText = statusText; self.statusColor = statusColor; self.voteScore = voteScore; self.userVoteStatus = userVoteStatus
    }
}
