//
//  VotesAPIService.swift
//  RepNet
//
//  Created by Angel Bosquez on 12/10/25.
//

import Foundation

// este archivo define el `votesapiservice`, el servicio que maneja
// las llamadas a la api para votar en los reportes.

// agrupa la logica para enviar votos.
// usa el `networkclient` generico para la peticion.
struct VotesAPIService {
    private let networkClient = NetworkClient()
    
    // envia un voto (upvote o downvote) para un reporte especifico.
    // - reportid: el id del reporte que se esta votando.
    // - votetype: el tipo de voto, que debe ser "upvote" o "downvote".
    func castVote(reportId: Int, voteType: String) async throws {
        // se asume que el endpoint para crear un voto es "/votes".
        let endpoint = AppConfig.votesURL
        // se crea el objeto `voterequestdto` que se enviara como el cuerpo json de la peticion.
        // se asume que este dto esta definido en otra parte.
        let voteData = VoteRequestDTO(reportId: reportId, voteType: voteType)
        
        // votar es una accion que requiere que el usuario este logueado.
        try await networkClient.request(
            endpoint: endpoint,
            method: "POST",
            body: voteData,
            isAuthenticated: true
        )
    }
}
