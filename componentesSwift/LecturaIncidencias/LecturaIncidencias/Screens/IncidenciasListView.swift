//
//  IncidenciasListView.swift
//  LecturaIncidencias
//
//  Created by José Molina on 29/09/25.
//

import SwiftUI

// Vista maestra (lista)
struct IncidenciasListView: View {
    @StateObject private var vm = IncidenciasViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Cargando incidencias…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") {
                            Task { await vm.fetch() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if vm.incidencias.isEmpty {
                    ContentUnavailableView("Sin datos", systemImage: "tray", description: Text("No se encontraron incidencias en el servidor."))
                } else {
                    List(vm.incidencias) { item in
                        NavigationLink(value: item) {
                            IncidenciaRow(item: item)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Incidencias")
            .navigationDestination(for: Incidencia.self) { item in
                IncidenciaDetailView(item: item)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await vm.fetch() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help("Actualizar")
                }
            }
            .task {
                await vm.fetch()
            }
        }
    }
}

#Preview{
       IncidenciasListView()
    }

    

