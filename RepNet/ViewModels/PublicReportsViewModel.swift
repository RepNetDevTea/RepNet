//
//  PublicReportsViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//

import Foundation
import SwiftUI

class PublicReportsViewModel: ObservableObject {
    
    @Published var selectedFilter: String = "Todos"
    let filterOptions = ["Todos", "Trending"]
    
    // Los datos de ejemplo ahora se crean con todos los campos requeridos por el nuevo 'Report.swift'
    // y se omite la información de estado.
    @Published var publicReports: [Report] = [
        Report(displayId: "PUB-001", title: "Vulnerabilidad en servidor", date: "29 septiembre 2025", url: "https://server.vulnerable.com", description: "Se encontró una vulnerabilidad de tipo X en el servidor.", category: "Otro", severity: "Severa"),
        Report(displayId: "PUB-002", title: "Campaña de Phishing masiva", date: "25 septiembre 2025", url: "https://phishing-campaign.com", description: "Una campaña de phishing está suplantando la identidad de la empresa Y.", category: "Phishing", severity: "Alta"),
        Report(displayId: "PUB-003", title: "Fallo en sistema de correo", date: "22 septiembre 2025", url: "https://mail-provider.com", description: "El sistema de correo presenta un fallo que permite el envío de spam.", category: "Malware", severity: "Media")
    ]
    
    var filteredReports: [Report] {
        return publicReports
    }
}
