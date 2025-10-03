//
//  CreateReportViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//


import Foundation
import Combine

@MainActor
class CreateReportViewModel: ObservableObject {
    
    private let reportsAPIService = ReportsAPIService()
    
    // Campos del formulario
    @Published var reportTitle = ""
    @Published var reportUrl = ""
    @Published var reportDescription = ""
    @Published var category = ""
    @Published var severity = ""
    @Published var impacts: Set<String> = []
    
    // --- PROPIEDADES AÑADIDAS ---
    // Estas propiedades faltaban y causaban los errores de compilación en la vista.
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var creationSuccessful = false
    @Published var isFormValid = false
    
    // Opciones para los menús, actualizadas con tus listas completas.
    let categoryOptions = ["Phishing", "Malware", "Fraude", "Spam", "Violación de privacidad", "Falsificación/Propiedad intelectual"]
    let severityOptions = ["Baja", "Media", "Alta", "Severa"]
    let impactOptions = ["Robo de credenciales", "Pérdida financiera", "Pérdida de la privacidad", "Infección de malware", "Riesgo legal", "Robo de identidad"]

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupFormValidation()
    }
    
    private func setupFormValidation() {
        // La validación se asegura de que los campos principales no estén vacíos.
        Publishers.CombineLatest4($reportTitle, $reportUrl, $reportDescription, $category)
            .combineLatest($severity)
            .map { (inputs, severity) in
                let (title, url, desc, cat) = inputs
                return !title.isEmpty && !url.isEmpty && !desc.isEmpty && !cat.isEmpty && !severity.isEmpty
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    func submitReport() async {
        isLoading = true; errorMessage = nil
        
        // Empaqueta los datos en el DTO para enviarlos a la API.
        let reportData = CreateReportRequestDTO(
            reportTitle: reportTitle,
            reportUrl: reportUrl,
            reportDescription: reportDescription,
            severity: mapSeverity(severity),
            siteDomain: extractDomain(from: reportUrl),
            tags: [category],
            impacts: Array(impacts) // Convierte el Set a un Array para el DTO
        )
        
        do {
            try await reportsAPIService.createReport(data: reportData)
            creationSuccessful = true
        } catch {
            print("❌ Error al crear reporte: \(error)")
            errorMessage = "No se pudo enviar el reporte. Inténtalo de nuevo."
        }
        isLoading = false
    }
    
    // --- Funciones auxiliares de mapeo ---
    private func mapSeverity(_ severityString: String) -> Int {
        switch severityString {
        case "Severa": return 3
        case "Alta": return 2
        case "Media": return 1
        default: return 0 // Baja
        }
    }
    
    private func extractDomain(from urlString: String) -> String {
        return URL(string: urlString)?.host ?? urlString
    }
}
