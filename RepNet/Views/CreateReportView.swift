//
//  CreateReportView.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//

import SwiftUI

// esta es la vista de swiftui para la pantalla de "crear reporte".
// obtiene todos sus datos del `createreportviewmodel`.

// -- componentes utilizados --
// - inputviewcomponent
// - dropdownpickercomponent
// - multiselectpickercomponent
// - fileuploadcomponent
// - primarybuttoncomponent
struct CreateReportView: View {
    
    // se crea la instancia del viewmodel que controla esta vista.
    @StateObject private var viewModel = CreateReportViewModel()
    // se usa para poder cerrar la vista programaticamente (ej. al cancelar o al terminar).
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        // `zstack` como vista raiz para poder mostrar el indicador de carga por encima de todo.
        ZStack {
            // `scrollview` para que el formulario sea desplazable en pantallas pequenas.
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // seccion para mostrar un mensaje de error si la api falla.
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage).foregroundColor(.errorRed).padding().frame(maxWidth: .infinity).background(Color.errorRed.opacity(0.1)).cornerRadius(8)
                    }
                    
                    // --- seccion de datos basicos ---
                    VStack(spacing: 15) {
                        InputViewComponent(text: $viewModel.reportTitle, placeholder: "nombre del reporte")
                        InputViewComponent(text: $viewModel.reportUrl, placeholder: "url del sitio o evidencia").keyboardType(.URL)
                        DropdownPickerComponent(title: "categoria", options: viewModel.categoryOptions, selection: $viewModel.category)
                        
                        // truco para anadir un placeholder a un `texteditor`: se pone en un `zstack`
                        // y se muestra un `text` por encima solo si el `texteditor` esta vacio.
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.reportDescription)
                                .frame(height: 150).padding(10).background(Color.textFieldBackground)
                                .cornerRadius(12).overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            if viewModel.reportDescription.isEmpty {
                                Text("descripcion de la amenaza...").foregroundColor(.textSecondary.opacity(0.5)).padding(15).allowsHitTesting(false)
                            }
                        }
                    }
                    
                    MultiSelectPickerComponent(title: "impactos potenciales", options: viewModel.impactOptions, selections: $viewModel.impacts)
                    
                    FileUploadComponent()
                    Text("maximo 1024x1024px").font(.caption).foregroundColor(.textSecondary).padding(.leading)
                }
                .padding()
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("crear reporte")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // se oculta el boton de regresar por defecto para usar uno personalizado.
            .disabled(viewModel.isLoading) // se deshabilita todo el formulario mientras se esta cargando.
            .toolbar {
                // boton personalizado para regresar, que cierra la vista modal.
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) { Image(systemName: "arrow.left") }
                }
                // el boton de enviar es un `primarybuttoncomponent`.
                // su estado `isenabled` esta bindeado a `isformvalid` del viewmodel,
                // por lo que solo se puede presionar si el formulario es valido.
                ToolbarItem(placement: .navigationBarTrailing) {
                    PrimaryButtonComponent(title: "enviar", action: { Task { await viewModel.submitReport() } }, isEnabled: viewModel.isFormValid)
                }
            }
            // alerta que se muestra cuando el reporte se envia con exito.
            // al presionar "ok", se cierra la pantalla.
            .alert("reporte enviado", isPresented: $viewModel.creationSuccessful) {
                Button("ok", role: .cancel) { presentationMode.wrappedValue.dismiss() }
            } message: { Text("tu reporte ha sido enviado para revision.") }
            
            // overlay de carga que se muestra cuando `isloading` es `true`.
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().scaleEffect(1.5).tint(.white)
            }
        }
    }
}
