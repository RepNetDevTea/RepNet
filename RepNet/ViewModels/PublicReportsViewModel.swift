//
//  PublicReportsViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//

import Foundation
import SwiftUI

// este es el viewmodel para la pantalla de "reportes publicos".
// su logica es mas simple que la de `myreportsviewmodel`, ya que solo se encarga
// de obtener la lista publica de reportes, ordenarla por fecha y mostrarla.
@MainActor
class PublicReportsViewModel: ObservableObject {
    
    private let reportsAPIService = ReportsAPIService()
    
    // -- datos y estado de la ui --
    // no necesita manejar filtros, solo la lista de reportes y los estados de carga/error.
    @Published var reports: [Report] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // carga los reportes publicos desde el backend.
    func fetchPublicReports() async {
        // evita que se hagan multiples llamadas si ya se esta cargando una (ej. pull-to-refresh).
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. se obtienen los datos crudos (dtos) de la api.
            let reportDTOs = try await reportsAPIService.fetchPublicReports()
            
            // 2. se convierten los dtos a modelos `report` de la ui.
            let mappedReports = mapDTOsToReports(reportDTOs)
            
            // 3. se ordenan los reportes, poniendo los mas nuevos (`createdat`) primero.
            self.reports = mappedReports.sorted { $0.createdAt > $1.createdAt }
            
        } catch {
            print("❌ error al obtener reportes publicos: \(error)")
            self.errorMessage = "no se pudieron cargar los reportes."
        }
        isLoading = false
    }
    
    // -- funcion de mapeo --
    
    // funcion auxiliar para convertir los dtos de la api a modelos `report`.
    // esta version es simplificada especificamente para la vista publica.
    private func mapDTOsToReports(_ dtos: [ReportResponseDTO]) -> [Report] {
        let formatter = ISO8601DateFormatter()
        
        return dtos.map { dto in
            // se convierte el string de la fecha a un objeto date real.
            let createdAtDate = formatter.date(from: dto.createdAt) ?? Date()
            
            return Report(
                displayId: String(dto.id),
                title: dto.reportTitle,
                date: createdAtDate.formatted(date: .long, time: .omitted), // se crea la fecha legible.
                url: dto.reportUrl,
                description: dto.reportDescription,
                category: dto.tags.first?.tagName ?? "general",
                // nota: se simplifican algunos campos para la vista publica.
                // la severidad se pone por defecto y no se incluyen el estado ni el color de estado.
                severity: "baja",
                user: dto.user ?? UserInReportDTO(username: "anonimo"),
                createdAt: createdAtDate, // se guarda la fecha real para poder ordenar.
                voteScore: dto.voteScore,
                userVoteStatus: dto.userVoteStatus
            )
        }
    }
}
