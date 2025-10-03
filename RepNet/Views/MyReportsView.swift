//
//  MyReportsView.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import SwiftUI

struct MyReportsView: View {
    
    @StateObject private var viewModel = MyReportsViewModel()
    
    var body: some View {
        // Envolvemos todo en un NavigationView para que la navegación a los detalles y a crear reporte funcione.
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    
                    SegmentedPickerComponent(options: viewModel.statusOptions, selectedOption: $viewModel.selectedStatus)
                    
                    HStack {
                        FilterButtonComponent(selection: $viewModel.selectedCategory, options: viewModel.categoryOptions, iconName: "line.3.horizontal.decrease")
                        FilterButtonComponent(selection: $viewModel.selectedSort, options: viewModel.sortOptions, iconName: "arrow.up.arrow.down")
                        Spacer()
                    }
                    
                    // --- CAMBIO CLAVE AQUÍ ---
                    // La vista ahora muestra diferentes cosas según el estado del ViewModel.
                    if viewModel.isLoading {
                        // Si está cargando, muestra un indicador de progreso.
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        // Si hay un error, muestra el mensaje.
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        // Si todo está bien, itera sobre la nueva propiedad 'reports'.
                        // Se ha reemplazado 'viewModel.filteredReports' por 'viewModel.reports'.
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
            // Llama a la función 'fetchReports' de la API cuando la vista aparece.
            .onAppear {
                Task {
                    await viewModel.fetchReports()
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hola,").font(.title2).foregroundColor(.textSecondary)
                Text("Angel Lopez").font(.largeTitle).fontWeight(.bold)
            }
            Spacer()
            // El NavigationLink para ir a la pantalla de Crear Reporte.
            NavigationLink(destination: CreateReportView()) {
                Text("Crear reporte")
                    .font(.buttonFont).foregroundColor(.white).padding(.horizontal, 20)
                    .padding(.vertical, 10).background(Color.primaryBlue).cornerRadius(12)
            }
        }
    }
}
