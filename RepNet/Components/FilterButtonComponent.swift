//
//  FilterButtonComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//


import SwiftUI

struct FilterButtonComponent: View {
    //titulo en binding para reflejar ubicacion
    @Binding var selection: String
    let options: [String]
    let iconName: String

    var body: some View {
        // El Button se convierte en un Menu
        Menu {
            // El contenido del menú son las opciones
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    Text(option)
                }
            }
        } label: {
            // La etiqueta del menú mantiene la apariencia original del botón
            HStack(spacing: 5) {
                Image(systemName: iconName)
                // El texto ahora muestra la selección actual
                Text(selection)
            }
            .font(.caption)
            .foregroundColor(.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(20)
        }
    }
}

// Usamos PreviewProvider para máxima compatibilidad
struct FilterButtonComponent_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var categorySelection = "Malware"
        let categories = ["Malware", "Phishing", "Otro"]
        
        @State private var sortSelection = "Severidad"
        let sortOptions = ["Severidad", "Fecha Asc", "Fecha Desc"]
        
        var body: some View {
            HStack {
                FilterButtonComponent(selection: $categorySelection, options: categories, iconName: "line.3.horizontal.decrease")
                FilterButtonComponent(selection: $sortSelection, options: sortOptions, iconName: "arrow.up.arrow.down")
            }
            .padding()
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}

