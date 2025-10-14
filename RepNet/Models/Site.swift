//
//  Site.swift
//  RepNet
//
//  Created by Angel Bosquez on 12/10/25.
//
// este es el modelo que representa un sitio web en la ui de la aplicacion.
// agrupa toda la informacion relevante de un sitio, incluyendo sus reportes asociados.
// `identifiable` permite que swiftui lo use en listas de forma eficiente.

import Foundation


struct Site: Identifiable {
    let id: Int      // el id del sitio que viene del backend.
    let domain: String      // el nombre de dominio del sitio
    let reputationScore: Int   //puntuacion de reputaacion de 0 a 100
    let reports: [Report]  //array de reportsde este sitio
}

