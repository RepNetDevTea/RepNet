//
//  ReportDetailViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 12/10/25.
//

import Foundation
import SwiftUI

// este es el viewmodel para la pantalla de "detalle de reporte".
// se encarga de mostrar la informacion de un reporte especifico y de manejar
// la logica de votacion (upvote/downvote).
@MainActor
class ReportDetailViewModel: ObservableObject {
    
    // el reporte que se esta mostrando en la pantalla.
    // al ser `@published`, la vista se actualizara automaticamente si cambia (ej. al votar).
    @Published var report: Report
    private let votesAPIService = VotesAPIService()
    
    // el viewmodel se inicializa con el reporte que la vista debe mostrar.
    init(report: Report) {
        self.report = report
    }
    
    // -- logica de votacion --
    // ambas funciones (`handleupvote` y `handledownvote`) usan una tecnica de "actualizacion optimista":
    // 1. se actualiza la ui inmediatamente para que la app se sienta rapida.
    // 2. se envia la peticion a la api en segundo plano.
    // 3. si la api falla, se revierte el cambio en la ui al estado original.
    
    // maneja la logica cuando el usuario presiona el boton de upvote.
    func handleUpvote() {
        // se guardan los valores originales por si la api falla.
        let originalStatus = report.userVoteStatus
        let originalScore = report.voteScore ?? 0
        var newStatus: UserVoteStatus? = nil
        var newScore = originalScore
        
        // se calcula el nuevo estado y puntuacion basado en el estado actual.
        if originalStatus == .upvoted { newStatus = nil; newScore -= 1 }
        else if originalStatus == .downvoted { newStatus = .upvoted; newScore += 2 }
        else { newStatus = .upvoted; newScore += 1 }
        
        // se actualiza la ui al instante con los nuevos valores.
        updateReportState(newScore: newScore, newStatus: newStatus)
        
        // se envia la peticion a la api en una tarea de fondo.
        Task {
            do {
                try await votesAPIService.castVote(reportId: Int(report.displayId) ?? 0, voteType: "upvote")
            } catch {
                // si la api falla, se revierte la ui a como estaba antes.
                print("❌ error al enviar upvote: \(error)")
                updateReportState(newScore: originalScore, newStatus: originalStatus)
            }
        }
    }
    
    // maneja la logica cuando el usuario presiona el boton de downvote.
    func handleDownvote() {
        let originalStatus = report.userVoteStatus
        let originalScore = report.voteScore ?? 0
        var newStatus: UserVoteStatus? = nil
        var newScore = originalScore
        
        if originalStatus == .downvoted { newStatus = nil; newScore += 1 }
        else if originalStatus == .upvoted { newStatus = .downvoted; newScore -= 2 }
        else { newStatus = .downvoted; newScore -= 1 }
        
        updateReportState(newScore: newScore, newStatus: newStatus)

        Task {
            do {
                try await votesAPIService.castVote(reportId: Int(report.displayId) ?? 0, voteType: "downvote")
            } catch {
                print("❌ error al enviar downvote: \(error)")
                updateReportState(newScore: originalScore, newStatus: originalStatus)
            }
        }
    }
    
    // funcion auxiliar para actualizar el estado del reporte.
    // como el struct `report` es inmutable (sus propiedades son `let`), no podemos
    // cambiar solo el `votescore`. en su lugar, creamos una instancia completamente nueva
    // copiando todos los valores antiguos y reemplazando los que cambiaron.
    private func updateReportState(newScore: Int, newStatus: UserVoteStatus?) {
        self.report = Report(
            id: report.id, displayId: report.displayId, title: report.title, date: report.date,
            url: report.url, description: report.description, category: report.category,
            severity: report.severity,
            user: report.user,
            createdAt: report.createdAt,
            statusText: report.statusText, statusColor: report.statusColor,
            voteScore: newScore,
            userVoteStatus: newStatus
        )
    }
}
