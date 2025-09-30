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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                headerView
                
                SegmentedPickerComponent(options: viewModel.statusOptions, selectedOption: $viewModel.selectedStatus)
                
                HStack {
                    
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
                
                //filtros se actualizan automaticamente
                ForEach(viewModel.filteredReports) { report in
                    NavigationLink(destination: Text("Detalle del reporte: \(report.title)")) {
                        ReportCardComponent(report: report)
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("Mis Reportes")
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Hola,")
                    .font(.title2)
                    .foregroundColor(.textSecondary)
                Text("Angel Lopez")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            Spacer()
            PrimaryButtonComponent(title: "Crear reporte", action: {})
        }
    }
}

#Preview {
    NavigationView {
        MyReportsView()
    }
}
