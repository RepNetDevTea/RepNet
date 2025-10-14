//
//  MyReportsViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import Foundation
import SwiftUI
import Combine /// Se importa Combine para poder "escuchar" los cambios en los filtros.

// este es el viewmodel para la pantalla de "mis reportes".
// su trabajo es obtener los reportes del usuario, manejar el estado de los filtros
// y transformar los datos de la api a un formato que la ui pueda entender.
@MainActor
class MyReportsViewModel: ObservableObject {
    
    private let reportsAPIService = ReportsAPIService()
    /// Se crea un 'contenedor' para guardar nuestras suscripciones a los cambios de los filtros.
    private var cancellables = Set<AnyCancellable>()
    
    // -- datos y estado principal --
    @Published var reports: [Report] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    // -- estado de los filtros --
    // la vista observara estos valores para filtrar y ordenar la lista de `reports`.
    @Published var selectedStatus: String = "Todos"
    @Published var selectedCategory: String = "Categoría"
    @Published var selectedSort: String = "Ordenar"
    
    // -- opciones para los filtros --
    // listas de opciones para los componentes de seleccion en la vista.
    let statusOptions = ["Todos", "Revisión", "Aceptados", "Rechazados"]
    let categoryOptions = ["Phishing", "Malware", "Fraude", "Spam", "Violación de privacidad", "Falsificación/Propiedad intelectual"]
    let sortOptions = ["Ordenar", "Severidad", "Fecha"]

    /// El inicializador ahora configura la "escucha" de los filtros.
    init() {
        /// Usamos Combine para combinar los 3 filtros en un solo flujo de datos.
        /// Cada vez que uno de los @Published 'selected...' cambia, este código se activa.
        Publishers.CombineLatest3($selectedStatus, $selectedCategory, $selectedSort)
            .dropFirst() /// Ignoramos la primera combinación de valores para que no se haga una llamada doble al inicio.
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) /// Esperamos 300ms después de un cambio para no sobrecargar la API.
            .sink { [weak self] (status, category, sortBy) in
                /// Cuando los filtros cambian (y después de la espera), ejecutamos este código.
                Task {
                    /// Llamamos a la función para obtener los reportes con los nuevos filtros.
                    await self?.fetchReports(status: status, category: category, sortBy: sortBy)
                }
            }
            .store(in: &cancellables)
    }

    /// La función 'fetchReports' ahora acepta los filtros como parámetros para construir la URL de la API.
    func fetchReports(status: String, category: String, sortBy: String) async {
        isLoading = true
        errorMessage = nil
        do {
            // 1. se obtienen los dtos (datos crudos) de la api, pasándole los filtros.
            let reportDTOs = try await reportsAPIService.fetchMyReports(status: status, category: category, sortBy: sortBy)
            // 2. se mapean los dtos a nuestro modelo `report`, que es el que usa la ui.
            self.reports = mapDTOsToReports(reportDTOs)
        } catch {
            print("❌ error al obtener mis reportes: \(error)")
            self.errorMessage = "no se pudieron cargar tus reportes."
        }
        isLoading = false
    }
    
    // -- funciones auxiliares de mapeo --
    // este grupo de funciones se encarga de convertir los dtos de la api
    // en los modelos `report` que la ui utiliza para mostrar la informacion.
    
    // convierte un arreglo de `reportresponsedto` a un arreglo de `report`.
    private func mapDTOsToReports(_ dtos: [ReportResponseDTO]) -> [Report] {
        let formatter = ISO8601DateFormatter()
        
        return dtos.map { dto in
            // se convierte el string de la fecha de la api a un objeto `date` de swift.
            let createdAtDate = formatter.date(from: dto.createdAt) ?? Date()
            
            // se crea el objeto `report` de la ui, traduciendo cada campo.
            // esto nos permite tener un modelo para la ui desacoplado del modelo de la red.
            return Report(
                displayId: String(dto.id),
                title: dto.reportTitle,
                date: createdAtDate.formatted(date: .long, time: .omitted),
                url: dto.reportUrl,
                description: dto.reportDescription,
                category: dto.tags.first?.tagName ?? "general",
                severity: mapSeverity(dto.severity),
                user: dto.user ?? UserInReportDTO(username: "anonimo"),
                createdAt: createdAtDate,
                statusText: dto.reportStatus,
                statusColor: mapStatusColor(dto.reportStatus),
                voteScore: dto.voteScore,
                userVoteStatus: dto.userVoteStatus
            )
        }
    }
    
    // traduce el numero de severidad del backend (ej. 3) a un texto legible (ej. "severa").
    private func mapSeverity(_ severity: Int) -> String {
        switch severity {
        case 3: return "severa"
        case 2: return "alta"
        case 1: return "media"
        default: return "baja"
        }
    }
    
    // traduce el string de estado del backend a un color especifico del tema de la app.
    private func mapStatusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending", "revision": return .statusReview
        case "accepted", "aceptado": return .statusAccepted
        case "rejected", "rechazado": return .statusRejected
        default: return .gray
        }
    }
}
