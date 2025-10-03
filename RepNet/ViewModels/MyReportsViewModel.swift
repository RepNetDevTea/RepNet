//
//  MyReportsViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import Foundation
import SwiftUI

@MainActor
class MyReportsViewModel: ObservableObject {
    
    private let reportsAPIService = ReportsAPIService()
    
    // --- PROPIEDAD CLAVE ---
    // Esta es la única lista que la vista necesita. Se llena desde la API.
    @Published var reports: [Report] = []
    
    // Propiedades para manejar el estado de la llamada de red.
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // Las propiedades de los filtros se mantienen.
    @Published var selectedStatus: String = "Todos"
    @Published var selectedCategory: String = "Categoría"
    @Published var selectedSort: String = "Ordenar"
    
    let statusOptions = ["Todos", "Revisión", "Aceptados", "Rechazados"]
    let categoryOptions = ["Phishing", "Malware", "Fraude", "Spam", "Violación de privacidad", "Falsificación/Propiedad intelectual"]
    let sortOptions = ["Ordenar", "Severidad", "Fecha"]

    /// Obtiene los reportes del usuario desde el backend.
    func fetchReports() async {
        isLoading = true
        errorMessage = nil
        do {
            let reportDTOs = try await reportsAPIService.fetchMyReports()
            // Mapeamos los DTOs del backend a nuestro modelo de UI 'Report'.
            self.reports = reportDTOs.map { dto in
                Report(
                    displayId: String(dto.id),
                    title: dto.reportTitle,
                    date: formatDate(dto.createdAt),
                    url: dto.reportUrl,
                    description: dto.reportDescription,
                    category: dto.tags.first?.tagName ?? "General",
                    severity: mapSeverity(dto.severity),
                    statusText: dto.reportStatus,
                    statusColor: mapStatusColor(dto.reportStatus)
                )
            }
        } catch {
            print("❌ Error al obtener reportes: \(error)")
            self.errorMessage = "No se pudieron cargar tus reportes."
        }
        isLoading = false
    }
    
    // --- Funciones de Mapeo Auxiliares ---
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            return date.formatted(date: .long, time: .omitted)
        }
        return String(dateString.prefix(10))
    }
    
    private func mapSeverity(_ severity: Int) -> String {
        switch severity {
        case 3: return "Severa"; case 2: return "Alta"; case 1: return "Media"; default: return "Baja"
        }
    }
    
    private func mapStatusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending", "revisión": return .statusReview
        case "accepted", "aceptado": return .statusAccepted
        case "rejected", "rechazado": return .statusRejected
        default: return .gray
        }
    }
}
