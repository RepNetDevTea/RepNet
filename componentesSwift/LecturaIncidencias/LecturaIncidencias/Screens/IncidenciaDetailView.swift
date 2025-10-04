//
//  IncidenciaDetailView.swift
//  LecturaIncidencias
//
//  Created by José Molina on 29/09/25.
//

import SwiftUI

// Vista detalle
struct IncidenciaDetailView: View {
    let item: Incidencia

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.titulo)
                    .font(.title2).bold()
                HStack {
                    Label("Creada:", systemImage: "calendar")
                    Text(item.fecha_creacion)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Divider()

                Text(item.descripcion)
                    .font(.body)

                if let link = URL(string: item.url), !item.url.isEmpty {
                    Link(destination: link) {
                        Label("Abrir enlace", systemImage: "link")
                    }
                    .font(.headline)
                }
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    IncidenciaDetailView(item: Incidencia(titulo: "Phishing bancario",
                                          descripcion: "SMS con liga a sitio falso para capturar datos.",
                                          url: "https://banco-falso.example",
                                          fecha_creacion: "2025-09-22"))
}
