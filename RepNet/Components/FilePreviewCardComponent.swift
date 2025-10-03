//
//  FilePreviewCardComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//


import SwiftUI

struct FilePreviewCardComponent: View {
    let file: FilePreview
    let onDelete: () -> Void // Acción para eliminar

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = file.image {
                // Vista previa para imágenes
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                // Vista previa para otros documentos
                VStack(spacing: 8) {
                    Image(systemName: file.iconName)
                        .font(.largeTitle)
                        .foregroundColor(file.iconColor)
                    Text(file.fileName)
                        .font(.caption)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Botón de eliminar
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
                    .font(.title2)
            }
            .offset(x: 8, y: -8)
        }
    }
}
