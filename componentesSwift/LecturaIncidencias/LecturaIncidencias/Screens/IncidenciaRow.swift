//
//  IncidenciaRow.swift
//  LecturaIncidencias
//
//  Created by José Molina on 29/09/25.
//

import SwiftUI

// Celda de la lista
struct IncidenciaRow: View {
    let item: Incidencia
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.titulo)
                .font(.headline)
                .lineLimit(2)
            Text(item.descripcion)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            HStack(spacing: 8) {
                Label(item.fecha_creacion, systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    IncidenciaRow(item: Incidencia(titulo: "Phishing bancario",
                                   descripcion: "SMS con liga a sitio falso para capturar datos.",
                                   url: "https://banco-falso.example",
                                   fecha_creacion: "2025-09-22"))
}
