//
//  MyReportsView.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import SwiftUI

// esta es la vista para la pestana "mis reportes".
// muestra un saludo, controles de filtro y la lista de reportes del usuario.

// -- componentes utilizados --
// - segmentedpickercomponent
// - filterbuttoncomponent
// - reportcardcomponent
struct MyReportsView: View {
    
    // `@observedobject` indica que esta vista no crea el viewmodel, sino que lo recibe
    // de una vista padre (en este caso, `maintabview`). esto permite que el estado
    // de los reportes y filtros se conserve al cambiar de pestana.
    @ObservedObject var viewModel: MyReportsViewModel
    
    // se inyecta el `authmanager` para poder mostrar el nombre del usuario en el saludo.
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        // se usa un `navigationview` para poder navegar a otras pantallas como el detalle o crear reporte.
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // el encabezado personalizado de la vista.
                    headerView
                    
                    // los componentes de filtro se conectan a las propiedades del viewmodel.
                    SegmentedPickerComponent(options: viewModel.statusOptions, selectedOption: $viewModel.selectedStatus)
                    
                    HStack {
                        FilterButtonComponent(selection: $viewModel.selectedCategory, options: viewModel.categoryOptions, iconName: "line.3.horizontal.decrease")
                        FilterButtonComponent(selection: $viewModel.selectedSort, options: viewModel.sortOptions, iconName: "arrow.up.arrow.down")
                        Spacer()
                    }
                    
                    // --- logica de contenido principal ---
                    // la vista decide que mostrar basandose en el estado del viewmodel.
                    if viewModel.isLoading {
                        // si esta cargando, muestra un spinner.
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        // si hay un error, muestra el mensaje.
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        // si todo esta bien, muestra la lista de reportes.
                        ForEach(viewModel.reports) { report in
                            // cada tarjeta de reporte es un link que lleva a la vista de detalle.
                            NavigationLink(destination: ReportDetailView(report: report)) {
                                ReportCardComponent(report: report)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.appBackground)
            // se oculta la barra de navegacion por defecto porque usamos un `headerview` personalizado.
            .navigationBarHidden(true)
            .onAppear {
                // cuando la vista aparece, carga los reportes solo si la lista esta vacia.
                // esto evita recargar los datos cada vez que se cambia de pestana.
                if viewModel.reports.isEmpty {
                    Task {
                        await viewModel.fetchReports()
                    }
                }
            }
        }
    }
    
    // -- vistas auxiliares --
    
    // una vista calculada para el encabezado personalizado, para mantener el `body` mas limpio.
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("hola,").font(.title2).foregroundColor(.textSecondary)
                // muestra el nombre del usuario guardado en el `authmanager`.
                Text("\(authManager.user?.name ?? "usuario") \(authManager.user?.fathersLastName ?? "")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
            // el `navigationlink` para ir a la pantalla de crear reporte.
            NavigationLink(destination: CreateReportView()) {
                Text("crear reporte")
                    .font(.buttonFont).foregroundColor(.white).padding(.horizontal, 20)
                    .padding(.vertical, 10).background(Color.primaryBlue).cornerRadius(12)
            }
        }
    }
}
