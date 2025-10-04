//
//  Incidencia.swift
//  LecturaIncidencias
//
//  Created by José Molina on 29/09/25.
//

import Foundation

// Modelo
struct Incidencia: Identifiable, Codable, Hashable {
    let id = UUID()                 // Generado localmente porque el JSON no trae id
    let titulo: String
    let descripcion: String
    let url: String
    let fecha_creacion: String

    enum CodingKeys: String, CodingKey {
        case titulo, descripcion, url, fecha_creacion
    }
}
