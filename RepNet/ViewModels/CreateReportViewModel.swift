//
//  CreateReportViewModel.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//

import Foundation
import Combine

// este es el viewmodel para la pantalla de "crear reporte".
// se encarga de manejar los datos del formulario, la validacion en tiempo real
// y la logica para enviar el nuevo reporte a la api.
@MainActor
class CreateReportViewModel: ObservableObject {
    
    private let reportsAPIService = ReportsAPIService()
    
    // -- campos del formulario --
    // estos se conectan (bindean) a los componentes de la vista.
    @Published var reportTitle = ""
    @Published var reportUrl = ""
    @Published var reportDescription = ""
    @Published var category = ""
    @Published var impacts: Set<String> = []
    
    // -- estado de la ui --
    // estos controlan elementos visuales como spinners, mensajes de error, etc.
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var creationSuccessful = false
    @Published var isFormValid = false
    
    // -- opciones para los pickers --
    // estas son las opciones que se mostraran en los componentes de seleccion en la vista.
    let categoryOptions = ["phishing", "malware", "fraude", "spam", "violacion de privacidad", "falsificacion/propiedad intelectual"]
    let impactOptions = ["robo de credenciales", "perdida financiera", "perdida de la privacidad", "infeccion de malware", "riesgo legal", "robo de identidad"]

    // para guardar las suscripciones de combine y evitar fugas de memoria.
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupFormValidation()
    }
    
    // configura la validacion reactiva del formulario usando combine.
    private func setupFormValidation() {
        // `combinelatest4` observa los 4 campos de texto principales.
        // `map` define la logica: el formulario es valido solo si ninguno de los campos esta vacio.
        // `assign` actualiza automaticamente la propiedad `isformvalid` cada vez que algo cambia.
        Publishers.CombineLatest4($reportTitle, $reportUrl, $reportDescription, $category)
            .map { (title, url, desc, cat) in
                return !title.isEmpty && !url.isEmpty && !desc.isEmpty && !cat.isEmpty
            }
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    // se llama cuando el usuario presiona el boton de enviar reporte.
    func submitReport() async {
        isLoading = true; errorMessage = nil
        
        // se crea el objeto dto que se enviara a la api, usando los datos del formulario.
        let reportData = CreateReportRequestDTO(
            reportTitle: reportTitle,
            reportUrl: reportUrl,
            reportDescription: reportDescription,
            siteDomain: extractDomain(from: reportUrl),
            tags: [category], // el backend espera un arreglo, aunque solo tenemos una categoria.
            impacts: Array(impacts) // el dto espera un arreglo, asi que convertimos el set.
        )
        
        do {
            // se llama al servicio de la api para crear el reporte.
            try await reportsAPIService.createReport(data: reportData)
            // si tiene exito, se actualiza el estado para que la vista pueda reaccionar (ej. cerrar la pantalla).
            creationSuccessful = true
        } catch {
            print("❌ error al crear reporte: \(error)")
            errorMessage = "no se pudo enviar el reporte. intentalo de nuevo."
        }
        isLoading = false
    }
    
    // una funcion auxiliar para extraer solo el dominio de una url completa.
    // ej. "https://www.pagina.com/articulo" -> "www.pagina.com"
    private func extractDomain(from urlString: String) -> String {
        return URL(string: urlString)?.host ?? urlString
    }
}
