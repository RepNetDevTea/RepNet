//
//  SearchViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 12/10/25.
//

import Foundation
import Combine
import SwiftUI

// Un enum para representar los diferentes estados de la pantalla de búsqueda.
enum SearchState {
    case initial // El estado antes de la primera búsqueda.
    case loading
    case success([Site]) // Contiene los resultados si la búsqueda es exitosa.
    case empty // La búsqueda fue exitosa pero no encontró nada.
    case error(String) // Contiene un mensaje de error.
}

@MainActor
class SearchViewModel: ObservableObject {
    
    private let searchAPIService = SearchAPIService()
    
    @Published var searchQuery = ""
    // La variable de estado única que controla toda la UI.
    @Published var state: SearchState = .initial
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSearch()
    }
    
    func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    // Si la barra de búsqueda está vacía, volvemos al estado inicial.
                    self?.state = .initial
                } else {
                    Task {
                        await self?.performSearch(query: query)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func performSearch(query: String) async {
        // Cambiamos al estado de carga.
        state = .loading
        
        do {
            // --- CAMBIO CLAVE AQUÍ ---
            // 'response' ahora es el array [SiteResponseDTO] que viene del backend.
            let response = try await searchAPIService.search(query: query)
            
            if response.isEmpty {
                // Si la API no devuelve sitios, cambiamos al estado vacío.
                state = .empty
            } else {
                // Si hay resultados, los mapeamos y cambiamos al estado de éxito.
                let sites = response.map { siteDTO in
                    let reports = mapDTOsToReports(siteDTO.reports)
                    return Site(id: siteDTO.id, domain: siteDTO.siteDomain, reputationScore: siteDTO.siteReputation, reports: reports)
                }
                state = .success(sites)
            }
        } catch {
            print("❌ Error en la búsqueda: \(error)")
            // Si hay un error, cambiamos al estado de error.
            state = .error("No se pudieron obtener los resultados.")
        }
    }
    
    // La función de mapeo se mantiene igual.
    private func mapDTOsToReports(_ dtos: [ReportResponseDTO]) -> [Report] {
        let formatter = ISO8601DateFormatter()
        return dtos.map { dto in
            let createdAtDate = formatter.date(from: dto.createdAt) ?? Date()
            return Report(
                displayId: String(dto.id),
                title: dto.reportTitle,
                date: createdAtDate.formatted(date: .long, time: .omitted),
                url: dto.reportUrl,
                description: dto.reportDescription,
                category: dto.tags.first?.tagName ?? "General",
                severity: "Baja", // Simplificado
                user: dto.user ?? UserInReportDTO(username: "Anónimo"),
                createdAt: createdAtDate,
                voteScore: dto.voteScore,
                userVoteStatus: dto.userVoteStatus
            )
        }
    }
}
