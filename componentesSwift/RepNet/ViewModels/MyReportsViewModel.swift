//
//  MyReportsViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import Foundation
import SwiftUI

class MyReportsViewModel: ObservableObject {
    
    // --- Estado de los Filtros ---
    @Published var selectedStatus: String = "Todos"
    @Published var selectedCategory: String = "Categoría"
    @Published var selectedSort: String = "Ordenar"
    
    // --- Opciones para los menús ---
    let statusOptions = ["Todos", "Revisión", "Aceptados", "Rechazados"]
    let categoryOptions = ["Categoría", "Malware", "Phishing", "Otro"]
    let sortOptions = ["Ordenar", "Severidad", "Fecha"]
    
    // --- Datos ---
    @Published var allReports: [Report] = [
        Report(title: "Reporte de Phishing", date: "6 septiembre 2025", category: "Phishing", severity: "Severa", statusText: "Revisión", statusColor: .statusReview),
        Report(title: "Actividad sospechosa", date: "2 septiembre 2025", category: "Malware", severity: "Media", statusText: "Revisión", statusColor: .statusReview),
        Report(title: "Correo fraudulento", date: "28 agosto 2025", category: "Phishing", severity: "Alta", statusText: "Aceptado", statusColor: .statusAccepted),
        Report(title: "Intento de acceso", date: "15 agosto 2025", category: "Otro", severity: "Baja", statusText: "Rechazado", statusColor: .statusRejected)
    ]
    
    var filteredReports: [Report] {
        var reportsToFilter = allReports
        
        // 1. Filtrar por estado (Revisión, Aceptado, etc.)
        if selectedStatus != "Todos" {
            reportsToFilter = reportsToFilter.filter { $0.statusText == selectedStatus }
        }
        
        // 2. Filtrar por categoría
        if selectedCategory != "Categoría" {
            reportsToFilter = reportsToFilter.filter { $0.category == selectedCategory }
        }
        
        // La lógica de ordenamiento se puede añadir aquí en el futuro
        // if selectedSort == "Severidad" { ... }
        
        return reportsToFilter
    }
}
