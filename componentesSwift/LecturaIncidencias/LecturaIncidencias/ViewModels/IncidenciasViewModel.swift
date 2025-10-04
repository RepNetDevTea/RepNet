//
//  IncidenciasViewModel.swift
//  LecturaIncidencias
//
//  Created by José Molina on 29/09/25.
//

import Foundation
// ViewModel
@MainActor
final class IncidenciasViewModel: ObservableObject {
    @Published var incidencias: [Incidencia] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let endpoint = URL(string: "http://martinmolina.com.mx/202513/data/incidencias.json")!

    func fetch() async {
        isLoading = true
        errorMessage = nil
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            // El JSON es un arreglo de objetos: [{...}, {...}]
            let decoded = try decoder.decode([Incidencia].self, from: data)
            incidencias = decoded
        } catch {
            errorMessage = "No se pudieron cargar las incidencias. \(error.localizedDescription)"
        }
        isLoading = false
    }
}
