//
//  ReportsAPIService.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//

import Foundation

// este archivo define el `reportsapiservice`, un servicio que centraliza
// todas las llamadas a la api que tienen que ver con reportes.

// agrupa las funciones para obtener y crear reportes.
// usa el `networkclient` generico para realizar las peticiones.
struct ReportsAPIService {
    private let networkClient = NetworkClient()
    
    /// Obtiene la lista de reportes del usuario, aplicando los filtros del lado del servidor.
    /// Esta función ha sido actualizada para aceptar parámetros que se convertirán en query params en la URL.
    /// - Parameters:
    ///   - status: El estado por el cual filtrar (ej. "pending").
    ///   - category: La categoría por la cual filtrar (ej. "Malware").
    ///   - sortBy: El campo por el cual ordenar.
    func fetchMyReports(status: String, category: String, sortBy: String) async throws -> [ReportResponseDTO] {
        
        /// 1. Empezamos con la URL base desde nuestro AppConfig. Usamos URLComponents
        ///    para poder añadir parámetros de forma segura.
        var components = URLComponents(string: AppConfig.reportsURL)
        components?.queryItems = []
        
        /// 2. Añadimos los filtros como 'query parameters' a la URL.
        ///    Solo se añaden si el usuario ha seleccionado una opción diferente a la por defecto.
        if status != "Todos" {
            /// Asumimos que el backend espera el parámetro 'status'.
            components?.queryItems?.append(URLQueryItem(name: "status", value: status.lowercased()))
        }
        
        if category != "Categoría" {
            /// Asumimos que el backend espera el parámetro 'tag'.
            components?.queryItems?.append(URLQueryItem(name: "tag", value: category))
        }
        
        if sortBy != "Ordenar" {
            /// Asumimos que el backend espera el parámetro 'sortBy'.
            components?.queryItems?.append(URLQueryItem(name: "sortBy", value: sortBy.lowercased()))
        }
        
        /// 3. Obtenemos la URL final con todos los parámetros. Si algo falla, usamos la URL base.
        let endpoint = components?.url?.absoluteString ?? AppConfig.reportsURL
        
        return try await networkClient.request(
            endpoint: endpoint,
            method: "GET",
            isAuthenticated: true
        )
    }
    
    // envia los datos de un nuevo reporte al backend para crearlo.
    // tambien es una accion autenticada, ya que solo un usuario logueado puede crear reportes.
    func createReport(data: CreateReportRequestDTO) async throws {
        let endpoint = AppConfig.reportsURL
        try await networkClient.request(
            endpoint: endpoint,
            method: "POST",
            body: data,
            isAuthenticated: true
        )
    }
    
    // obtiene la lista de reportes publicos, los que puede ver cualquier persona (logueada o no).
    // usa el mismo endpoint que `fetchmyreports`, pero la diferencia clave es `isauthenticated: false`.
    // el backend interpreta la ausencia del token como una solicitud de los reportes publicos.
    func fetchPublicReports() async throws -> [ReportResponseDTO] {
        let endpoint = AppConfig.reportsURL
        return try await networkClient.request(
            endpoint: endpoint,
            method: "GET",
            isAuthenticated: false // <-- esta es la diferencia.
        )
    }
}
