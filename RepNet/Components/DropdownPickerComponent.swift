//
//  DropdownPickerComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//


import SwiftUI

struct DropdownPickerComponent: View {
    let title: String
    let options: [String]
    @Binding var selection: String

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    // --- CAMBIO AQUÍ ---
                    // Ahora simplemente usamos el TagComponent "inteligente" dentro del menú.
                    // Ya no necesita las funciones auxiliares de color que tenía antes.
                    TagComponent(text: option)
                }
            }
        } label: {
            HStack {
                Text(selection.isEmpty ? title : selection)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
            }
            .font(.bodyText)
            .foregroundColor(selection.isEmpty ? .textSecondary : .textPrimary)
            .padding()
            .background(Color.textFieldBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

// La vista previa no necesita cambios, solo se asegura de que el componente compile.
struct DropdownPickerComponent_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var categorySelection = ""
        let categories = ["Otro", "Malware", "Phishing"]
        
        @State private var severitySelection = "Alta"
        let severities = ["Severa", "Alta", "Media", "Baja"]
        
        var body: some View {
            VStack(spacing: 20) {
                DropdownPickerComponent(
                    title: "Categoría",
                    options: categories,
                    selection: $categorySelection
                )
                
                DropdownPickerComponent(
                    title: "Severidad",
                    options: severities,
                    selection: $severitySelection
                )
            }
            .padding()
            .background(Color.appBackground)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
