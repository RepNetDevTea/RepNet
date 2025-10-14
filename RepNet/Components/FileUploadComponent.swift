//
//  FileUploadComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//esta madre esta mal hecha y es 100% ai, pequeno detalle que no hay hover en movil
//componente para seleccionar varios archivos
/// una vez seleccionados, muestra una vista previa horizontal de los archivos,
/// permitiendo al usuario eliminar cualquiera de ellos.

import SwiftUI
import UniformTypeIdentifiers

struct FileUploadComponent: View {
    
    //binding de filepreview
    @State private var selectedFiles: [FilePreview] = []
    //tipos de archivos que se permiten 
    @State private var showFileImporter = false

    var body: some View {
        VStack(spacing: 20) {
            // --- ZONA PARA CARGAR ARCHIVOS ---
            Button(action: { showFileImporter = true }) {
                VStack(spacing: 10) {
                    Image(systemName: "arrow.up.doc")
                        .font(.largeTitle)
                    Text("Toca para cargar archivos")
                        .font(.bodyText)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [8]))
                        .foregroundColor(.gray.opacity(0.5))
                )
            }
            
            // --- VISTA PREVIA DE ARCHIVOS SELECCIONADOS ---
            if !selectedFiles.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(selectedFiles) { file in
                            FilePreviewCardComponent(file: file) {
                                // Acción para eliminar el archivo
                                selectedFiles.removeAll { $0.id == file.id }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 110)
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            // Permitimos varios tipos de archivo y selección múltiple
            allowedContentTypes: [UTType.image, .pdf, .spreadsheet, .presentation, .plainText],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                // Creamos un FilePreview por cada URL seleccionada
                let newFiles = urls.map { FilePreview(url: $0) }
                selectedFiles.append(contentsOf: newFiles)
            case .failure(let error):
                print("Error al seleccionar archivos: \(error.localizedDescription)")
            }
        }
        .animation(.easeInOut, value: selectedFiles.count)
    }
}

struct FileUploadComponent_Previews: PreviewProvider {
    static var previews: some View {
        FileUploadComponent()
            .padding()
    }
}
