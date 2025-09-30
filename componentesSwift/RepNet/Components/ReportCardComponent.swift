//
//  Report.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//


import SwiftUI

// Modelo de datos de ejemplo para la vista previa

struct ReportCardComponent: View {
    let report: Report

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
            
                HStack {
                    TagComponent(text: report.category, backgroundColor: .categoryPhishing, textColor: .categoryPhishingText)
                    TagComponent(text: report.severity, backgroundColor: .severityHigh, textColor: .severityHighText)
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
            
            // Estado y Chevron
            VStack(alignment: .trailing) {
                StatusIndicatorComponent(statusText: report.statusText, statusColor: report.statusColor)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.textSecondary)
            }
            .frame(height: 50) // Alinea el chevron con el centro
        }
        .padding()
        .background(Color.textFieldBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
}

#Preview {
    let sampleReport = Report(
        title: "Reporte nombre",
        date: "2 septiembre 2025",
        category: "Phishing",
        severity: "Alta",
        statusText: "Revisión",
        statusColor: .statusReview
    )
    
    return ReportCardComponent(report: sampleReport)
        .padding()
        .background(Color.appBackground)
}
