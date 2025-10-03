//
//  Report.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import Foundation
import SwiftUI

struct Report: Identifiable {
    let id: UUID
    let displayId: String // ID visible para el usuario
    let title: String
    let date: String
    let url: String
    let description: String
    let category: String
    let severity: String
    
    // Propiedades opcionales para el estado
    let statusText: String?
    let statusColor: Color?
    
    // Placeholder para los archivos adjuntos
    let attachments: [UIImage] = []

    init(id: UUID = UUID(), displayId: String, title: String, date: String, url: String, description: String, category: String, severity: String, statusText: String? = nil, statusColor: Color? = nil) {
        self.id = id
        self.displayId = displayId
        self.title = title
        self.date = date
        self.url = url
        self.description = description
        self.category = category
        self.severity = severity
        self.statusText = statusText
        self.statusColor = statusColor
    }
}



