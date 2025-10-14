//
//  SearchAPIService.swift
//  RepNet
//
//  Created by Angel Bosquez on 12/10/25.
//

import Foundation

// Un servicio dedicado a las llamadas de red para la funcionalidad de búsqueda.
struct SearchAPIService {
    private let networkClient = NetworkClient()
    
    // Busca sitios en el backend por dominio.
    func search(query: String) async throws -> [SiteResponseDTO] {
        
        // Construimos la URL para llamar a 'GET /sites' con un parámetro de consulta.
        // Asumimos que el parámetro es 'domain'. Si es 'q' o 'search', solo tendríamos
        // que cambiar esa palabra aquí.
        let endpoint = AppConfig.sitesURL + "?domain=\(query)"
        
        // Ahora esperamos recibir directamente un array de sitios.
        return try await networkClient.request(
            endpoint: endpoint,
            method: "GET"
        )
    }
}
