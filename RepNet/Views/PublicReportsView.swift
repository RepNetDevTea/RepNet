//
//  PublicReportsView.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//
//hecho por ia, necesita cambios

import SwiftUI

struct PublicReportsView: View {

    // CAMBIO 1 (Confirmación): Se mantiene el @StateObject, pero ahora es para nuestro nuevo ViewModel.
    // Esto es correcto, ya que esta vista ahora tiene su propia lógica independiente.
    @StateObject private var viewModel = PublicReportsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                headerView
                
                // CAMBIO 2 (AÑADIDO): Se ha añadido el SegmentedPickerComponent.
                // Este componente ahora toma las opciones ["Todos", "Trending"] del `PublicReportsViewModel`
                // y vincula la selección a la variable `selectedFilter` del mismo ViewModel.
                SegmentedPickerComponent(options: viewModel.filterOptions, selectedOption: $viewModel.selectedFilter)
                
                // CAMBIO 3 (ELIMINADO): Se ha eliminado toda la HStack que contenía los dos FilterButtonComponent.
                // Como esta pantalla solo necesita los filtros "Todos" y "Trending", los menús
                // desplegables para categoría y orden ya no son necesarios aquí.
                
                ForEach(viewModel.filteredReports) { report in
                    NavigationLink(destination: Text("Detalle del reporte público: \(report.title)")) {
                        ReportCardComponent(report: report)
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationBarHidden(true)
    }
    
    // CAMBIO 4 (Estilístico): He simplificado el header para que sea más directo,
    // eliminando el subtítulo y haciendo el título principal más prominente.
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Reportes Públicos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}

// La vista previa se mantiene igual, ya que no depende de la lógica interna.
struct PublicReportsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PublicReportsView()
        }
    }
}
