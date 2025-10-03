//
//  CreateReportView.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//


import SwiftUI

struct CreateReportView: View {
    
    @StateObject private var viewModel = CreateReportViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) { // Aumentamos el espaciado
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.errorRed)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.errorRed.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    // --- Sección de Datos Básicos ---
                    VStack(spacing: 15) {
                        InputViewComponent(text: $viewModel.reportTitle, placeholder: "Nombre del reporte")
                        InputViewComponent(text: $viewModel.reportUrl, placeholder: "URL del sitio o evidencia")
                            .keyboardType(.URL)
                        DropdownPickerComponent(title: "Categoría", options: viewModel.categoryOptions, selection: $viewModel.category)
                        DropdownPickerComponent(title: "Severidad", options: viewModel.severityOptions, selection: $viewModel.severity)
                        
                        // Usamos un placeholder para el TextEditor
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.reportDescription)
                                .frame(height: 150)
                                .padding(10)
                                .background(Color.textFieldBackground)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                            
                            if viewModel.reportDescription.isEmpty {
                                Text("Descripción de la amenaza...")
                                    .foregroundColor(.textSecondary.opacity(0.5))
                                    .padding(15)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    
                    // --- NUEVA SECCIÓN: Selección de Impactos ---
                    MultiSelectPickerComponent(
                        title: "Impactos Potenciales",
                        options: viewModel.impactOptions,
                        selections: $viewModel.impacts
                    )
                    
                    // --- Componente de Carga de Archivos ---
                    FileUploadComponent()
                }
                .padding()
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationTitle("Crear Reporte")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .disabled(viewModel.isLoading)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) { Image(systemName: "arrow.left") }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    PrimaryButtonComponent(
                        title: "Enviar",
                        action: { Task { await viewModel.submitReport() } },
                        isEnabled: viewModel.isFormValid
                    )
                }
            }
            .alert("Reporte Enviado", isPresented: $viewModel.creationSuccessful) {
                Button("OK", role: .cancel) { presentationMode.wrappedValue.dismiss() }
            } message: {
                Text("Tu reporte ha sido enviado para revisión.")
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView().scaleEffect(1.5).tint(.white)
            }
        }
    }
}

struct CreateReportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateReportView()
        }
    }
}
