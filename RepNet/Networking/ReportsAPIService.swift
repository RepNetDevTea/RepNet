//
//  ReportsAPIService.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//


import Foundation

/// Un servicio dedicado a las llamadas de red para crear y obtener reportes.
struct ReportsAPIService {
    private let networkClient = NetworkClient()
    
    /// Obtiene la lista de reportes pertenecientes al usuario autenticado.
    func fetchMyReports() async throws -> [ReportResponseDTO] {
        // Asumiremos que el endpoint es "/reports/me". ¡Confírmalo!
        let endpoint = AppConfig.server + "/reports/me"
        return try await networkClient.request(
            endpoint: endpoint,
            method: "GET",
            isAuthenticated: true
        )
    }
    
    /// Envía un nuevo reporte al backend.
    func createReport(data: CreateReportRequestDTO) async throws {
        let endpoint = AppConfig.server + "/reports"
        try await networkClient.request(
            endpoint: endpoint,
            method: "POST",
            body: data,
            isAuthenticated: true
        )
    }
}