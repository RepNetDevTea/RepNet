//
//  some.swift
//  ManejoFoto
//
//  Created by José Molina on 28/09/25.
//SOLO SE PUEDE USAR EL MANEJO DE LA CAMARA EN UIKIT CON PHOTOSUI

import SwiftUI
import PhotosUI
import UIKit

struct ContentView: View {
    @State private var selectedUIImage: UIImage?
    @State private var showCamera = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var uploadStatus: String?
    
    var body: some View {
        VStack(spacing: 16) {
            // Botones superiores
            HStack(spacing: 12) {
                Button {
                    showCamera = true
                } label: {
                    Label("Cámara", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))
                
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Label("Rollo", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            
            // Botón para enviar al servidor
            Button {
                if let image = selectedUIImage {
                    uploadImage(image)
                }
            } label: {
                Label("Enviar al servidor", systemImage: "paperplane.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedUIImage == nil)
            .padding(.horizontal)
            
            // Estado de la subida
            if let status = uploadStatus {
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Preview de la imagen
            Group {
                if let image = selectedUIImage {
                    ScrollView {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                            .padding()
                    }
                    .frame(height: 300)
                } else {
                    ContentUnavailableView(
                        "Sin imagen",
                        systemImage: "photo",
                        description: Text("Elige una foto del rollo o toma una con la cámara.")
                    )
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $selectedUIImage)
                .ignoresSafeArea()
        }
        .onChange(of: photoPickerItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedUIImage = uiImage
                }
            }
        }
    }
    
    /// Función para subir imagen al servidor
    func uploadImage(_ image: UIImage) {
        guard let url = URL(string: "http://localhost:3000/files/upload"),
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            uploadStatus = "Error al preparar la imagen"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Límite del multipart
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Construcción del body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"foto.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Envío
        URLSession.shared.uploadTask(with: request, from: body) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    uploadStatus = "Error: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    uploadStatus = "Imagen enviada con éxito ✅"
                } else {
                    uploadStatus = "Fallo en la subida ❌"
                }
            }
        }.resume()
    }
}

/// Envoltura de UIKit para la cámara
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


#Preview {
    ContentView()
}

