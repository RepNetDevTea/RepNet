//
//  ReportDetailView.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//


import SwiftUI

struct ReportDetailView: View {
    
    let report: Report
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // --- Tarjeta Principal de Información ---
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                    //    TagComponent(text: report.category, backgroundColor: .categoryPhishing, textColor: .categoryPhishingText)
                       // TagComponent(text: report.severity, backgroundColor: .severitySevere, textColor: .severitySevereText)
                        Spacer()
                    }
                    
                    Text(report.title)
                        .font(.title).bold()
                    
                    Text(report.date)
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                    
                    Divider()
                    
                    InfoRow(label: "ID:", value: report.displayId)
                    InfoRow(label: "URL:", value: report.url)
                    
                    Divider()

                    InfoRow(label: "Descripción:", value: report.description)
                    
                    // --- Sección de Archivos Adjuntos ---
                    if !report.attachments.isEmpty {
                        Divider()
                        Text("Archivo(s)")
                            .font(.headline)
                        // Aquí se mostrarían las vistas previas de los archivos
                    }
                }
                .padding()
                .background(Color.textFieldBackground)
                .cornerRadius(16)
            }
            .padding()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                // Este botón podría llevar a una vista de edición en el futuro
                PrimaryButtonComponent(title: "Editar", action: {})
            }
        }
    }
}

// Pequeño componente auxiliar para las filas de información
private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.body)
        }
    }
}

// Vista Previa con datos de ejemplo
struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
       //     ReportDetailView(report: MyReportsViewModel().allReports.first!)
        }
    }
}
