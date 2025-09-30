//
//  PublicReportsView.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//
//hecho por ia, necesita cambios

import SwiftUI

struct PublicReportsView: View {

    @StateObject private var viewModel = MyReportsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                headerView
                
                SegmentedPickerComponent(options: viewModel.statusOptions, selectedOption: $viewModel.selectedStatus)
                
                HStack {
                    // Llamamos a los FilterButtonComponent de la nueva manera
                    FilterButtonComponent(
                        selection: $viewModel.selectedCategory,
                        options: viewModel.categoryOptions,
                        iconName: "line.3.horizontal.decrease"
                    )
                    
                    FilterButtonComponent(
                        selection: $viewModel.selectedSort,
                        options: viewModel.sortOptions,
                        iconName: "arrow.up.arrow.down"
                    )
                    Spacer()
                }
                
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
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Reportes")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                Text("Públicos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}

struct PublicReportsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PublicReportsView()
        }
    }
}
