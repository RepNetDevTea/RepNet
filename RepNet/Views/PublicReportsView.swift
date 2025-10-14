//
//  PublicReportsView.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//
//hecho por ia, necesita cambios

import SwiftUI

// esta es la vista para la pestana "reportes publicos".
// es una version mas simple que `myreportsview`, ya que no tiene filtros,
// solo muestra una lista de reportes ordenada por fecha.

// -- componentes utilizados --
// - reportcardcomponent
struct PublicReportsView: View {
    
    // `@observedobject` indica que la vista recibe el viewmodel de un padre (`maintabview`).
    // esto conserva el estado de la lista al cambiar de pestana.
    @ObservedObject var viewModel: PublicReportsViewModel
    
    var body: some View {
        // se usa un `navigationview` para poder navegar a la pantalla de detalle de cada reporte.
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    
                    // --- logica de contenido principal ---
                    // este bloque `if/else` maneja los 4 posibles estados de la vista.
                    if viewModel.isLoading {
                        // 1. estado de carga: muestra un spinner.
                        ProgressView().frame(maxWidth: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        // 2. estado de error: muestra el mensaje de error.
                        Text(errorMessage).foregroundColor(.red).padding()
                    } else if viewModel.reports.isEmpty {
                        // 3. estado vacio: la carga fue exitosa pero no habia reportes.
                        Text("no hay reportes publicos disponibles en este momento.")
                            .foregroundColor(.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        // 4. estado de exito: muestra la lista de reportes.
                        ForEach(viewModel.reports) { report in
                            NavigationLink(destination: ReportDetailView(report: report)) {
                                ReportCardComponent(report: report)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationBarHidden(true)
            .onAppear {
                // se carga la data inicial solo si la lista de reportes esta vacia,
                // para no recargarla cada vez que se entra a la pestana.
                if viewModel.reports.isEmpty {
                    Task {
                        await viewModel.fetchPublicReports()
                    }
                }
            }
        }
    }
    
    // -- vistas auxiliares --
    
    // una vista calculada para el encabezado, solo muestra el titulo de la pantalla.
    private var headerView: some View {
        HStack {
            Text("reportes publicos").font(.largeTitle).fontWeight(.bold)
            Spacer()
        }
    }
}

// mark: - preview

struct PublicReportsView_Previews: PreviewProvider {
    static var previews: some View {
        // para la vista previa, creamos una nueva instancia del viewmodel.
        PublicReportsView(viewModel: PublicReportsViewModel())
    }
}
