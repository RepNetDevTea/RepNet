//
//  FileUploadComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//esta madre esta mal hecha y es 100% ai, pequeno detalle que no hay hover en movil 

import SwiftUI
import UniformTypeIdentifiers // Necesario para especificar los tipos de archivo

struct FileUploadComponent: View {
    
    // MARK: - State Properties
    // Guarda la imagen seleccionada para la vista previa
    @State private var selectedImage: UIImage?
    // Controla si se muestra el selector de archivos nativo
    @State private var showFileImporter = false
    // Detecta si un archivo está siendo arrastrado sobre el componente
    @State private var isTargetedForDrop = false

    var body: some View {
        Group {
            // Si no hay imagen seleccionada, muestra la zona para cargar
            if selectedImage == nil {
                emptyStateView
            } else {
                // Si ya hay una imagen, muestra la vista previa
                previewStateView
            }
        }
        // MODIFICADOR PARA ABRIR EL SELECTOR DE ARCHIVOS AL TOCAR
        .onTapGesture {
            showFileImporter = true
        }
        // MODIFICADOR PARA EL "DRAG AND DROP"
        .onDrop(of: [UTType.image], isTargeted: $isTargetedForDrop) { providers in
            // Cuando se suelta el archivo, intenta cargarlo como imagen
            providers.first?.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.selectedImage = image as? UIImage
                }
            }
            return true
        }
        // MODIFICADOR QUE PRESENTA LA VISTA NATIVA PARA SELECCIONAR ARCHIVOS
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [UTType.image], // Solo permite imágenes por ahora
            onCompletion: { result in
                switch result {
                case .success(let url):
                    // Si el usuario selecciona un archivo, intenta cargarlo
                    if let imageData = try? Data(contentsOf: url) {
                        self.selectedImage = UIImage(data: imageData)
                    }
                case .failure(let error):
                    print("Error al seleccionar archivo: \(error.localizedDescription)")
                }
            }
        )
        .animation(.easeInOut, value: selectedImage)
        .animation(.easeInOut, value: isTargetedForDrop)
    }
    
    // --- VISTAS AUXILIARES PARA CADA ESTADO ---

    /// La vista que se muestra cuando no hay ningún archivo seleccionado.
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "arrow.up.doc")
                .font(.largeTitle)
            Text("Cargar archivos")
                .font(.bodyText)
                .fontWeight(.semibold)
        }
        .foregroundColor(isTargetedForDrop ? .primaryBlue : .textSecondary)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                .foregroundColor(isTargetedForDrop ? .primaryBlue : .gray.opacity(0.5))
                .background(isTargetedForDrop ? Color.primaryBlue.opacity(0.1) : Color.clear)
        )
    }
    
    /// La vista que se muestra después de que se ha seleccionado un archivo.
    private var previewStateView: some View {
        ZStack(alignment: .topTrailing) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
            // Botón para eliminar la selección
            Button(action: {
                self.selectedImage = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .padding(8)
        }
    }
}

// Vista previa actualizada para mostrar los diferentes estados
struct FileUploadComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            // 1. Estado por defecto
            Text("Estado por Defecto").font(.headline)
            FileUploadComponent()
            
            // 2. Estado de Contenido (con una imagen de sistema como ejemplo)
            Text("Estado con Archivo Seleccionado").font(.headline)
            FileUploadComponentWithPreview()
        }
        .padding()
    }
    
    // Pequeño contenedor para simular una imagen cargada en la vista previa
    private struct FileUploadComponentWithPreview: View {
        @State var image: UIImage? = UIImage(systemName: "photo.artframe")
        var body: some View {
            // Este es un truco para mostrar el estado con contenido en la preview
            // El componente real no necesita esta lógica extra.
            ZStack(alignment: .topTrailing) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable().scaledToFit().frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                Button(action: { self.image = nil }) {
                    Image(systemName: "xmark.circle.fill").font(.title2)
                        .foregroundColor(.white).background(Circle().fill(Color.black.opacity(0.6)))
                }.padding(8)
            }
        }
    }
}
