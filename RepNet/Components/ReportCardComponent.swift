//
//  Report.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//

import SwiftUI

struct ReportCardComponent: View {
    let report: Report

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                // --- CAMBIO AQUÍ ---
                // Ahora simplemente llamamos al TagComponent "inteligente" pasándole el texto.
                // Ya no necesita los parámetros de color.
                HStack {
                    TagComponent(text: report.category)
                    TagComponent(text: report.severity)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(report.title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                    Text(report.date)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                if let statusText = report.statusText, let statusColor = report.statusColor {
                    StatusIndicatorComponent(statusText: statusText, statusColor: statusColor)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.textSecondary)
            }
            .frame(height: 50)
        }
        .padding()
        .background(Color.textFieldBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
}

// La vista previa también se actualiza para usar el nuevo modelo de Report.
struct ReportCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            let reportWithStatus = Report(
                displayId: "123", title: "Reporte con Estado", date: "2 sep 2025", url: "", description: "",
                category: "Phishing", severity: "Alta", statusText: "Revisión", statusColor: .statusReview
            )
            ReportCardComponent(report: reportWithStatus)
            
            let reportWithoutStatus = Report(
                displayId: "456", title: "Reporte sin Estado", date: "2 sep 2025", url: "", description: "",
                category: "Malware", severity: "Media"
            )
            ReportCardComponent(report: reportWithoutStatus)
        }
        .padding()
        .background(Color.appBackground)
    }
}
