//
//  SiteCardComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 12/10/25.
//
// una tarjeta expandible que muestra la informacion de un sitio web.
// el encabezado muestra un resumen (dominio, reputacion) y al tocarlo,
// revela una lista de los reportes asociados a ese sitio.

import SwiftUI

struct SiteCardComponent: View {
    
    // el objeto `site` que contiene la informacion a mostrar.
    
    let site: Site
    
    // un estado privado que controla si la lista de reportes esta visible (expandida) o no.
    
    @State private var isExpanded = false

    // el encabezado completo funciona como un boton para expandir/colapsar la tarjeta.
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
    // la animacion `easeinout` suaviza la aparicion de la lista de reportes.
            
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sitio Web")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                        Text(site.domain)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .foregroundColor(.textPrimary)
                    }
                    
                    Spacer()
                    
                    reputationRing
                    
    // la flecha rota 180 grados para indicar visualmente el estado expandido.
                    
                        .font(.headline)
                        .foregroundColor(.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }

            
    // esta seccion solo se construye y se muestra en la vista si la tarjeta esta expandida
    // y si el sitio tiene al menos un reporte.
            
            if isExpanded && !site.reports.isEmpty {
                VStack(alignment: .leading) {
                    Text("Reportes Asociados (\(site.reports.count))")
                        .font(.headline)
                        .padding(.top, 20)
                    
        // cada reporte es un enlace a su vista de detalle.
                    ForEach(site.reports) { report in
                        NavigationLink(destination: ReportDetailView(report: report)) {
                            ReportCardComponent(report: report)
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding()
        .background(Color.textFieldBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
    
// una vista auxiliar para mantener el `body` mas limpio.
// dibuja el anillo de reputacion basado en el `reputationscore` del sitio.

    private var reputationRing: some View {
        ZStack {
            
            // el circulo de fondo, semitransparente.
            Circle()
                .stroke(Color.primaryBlue.opacity(0.2), lineWidth: 5)
            // el circulo de progreso, que se dibuja parcialmente.
            Circle()
            
            // el modificador `.trim` recorta el circulo para que coincida con el puntaje de reputacion.
                .trim(from: 0, to: CGFloat(site.reputationScore) / 100.0)
                .stroke(Color.primaryBlue, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // el texto del porcentaje en el centro.
            Text("\(site.reputationScore)%")
                .font(.caption)
                .fontWeight(.bold)
        }
        .frame(width: 50, height: 50)
    }
}

//preview con ia 
struct SiteCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = UserInReportDTO(username: "previewUser")
        let sampleReports = [
            Report(displayId: "1", title: "Intento de Phishing", date: "Hoy", url: "", description: "", category: "Phishing", severity: "Alta", user: sampleUser, createdAt: Date(), statusText: "Aceptado", statusColor: .green),
            Report(displayId: "2", title: "Malware detectado", date: "Ayer", url: "", description: "", category: "Malware", severity: "Severa", user: sampleUser, createdAt: Date(), statusText: "Aceptado", statusColor: .green)
        ]
        let sampleSite = Site(id: 1, domain: "sitio-peligroso.com", reputationScore: 25, reports: sampleReports)
        
        return ScrollView {
            SiteCardComponent(site: sampleSite)
                .padding()
        }
        .background(Color.appBackground)
    }
}
