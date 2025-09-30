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
                    //llamada para reutilizar tag componente
                    TagComponent(
                        text: option,
                        backgroundColor: tagBackgroundColor(for: option),
                        textColor: tagTextColor(for: option)
                    )
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
    //anadir parte para anadir mas categorias
    // logica de estilo de chats
    // si hay mas complejidad moverla a su mismo componente
    //anadir aqui mas categorias cuando sepas cuales son
    private func tagBackgroundColor(for option: String) -> Color {
        switch option {
        case "Malware": return .categoryMalware
        case "Phishing": return .categoryPhishing
        case "Severa": return .severitySevere
        case "Alta": return .severityHigh
        case "Media": return .severityMedium
        default: return .gray.opacity(0.1)
        }
    }
    
    private func tagTextColor(for option: String) -> Color {
        switch option {
        case "Malware": return .categoryMalwareText
        case "Phishing": return .categoryPhishingText
        case "Severa": return .severitySevereText
        case "Alta": return .severityHighText
        case "Media": return .severityMediumText
        default: return .textPrimary
        }
    }
}

// Vista previa hecha por ai
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
