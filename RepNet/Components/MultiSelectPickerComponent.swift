//
//  MultiSelectPickerComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 02/10/25.
//

// un selector que permite al usuario elegir multiples opciones de una lista.
// presenta las opciones como una cuadricula detags  que se ajusta al espacio.


import SwiftUI

struct MultiSelectPickerComponent: View {
    let title: String
    //arreglo con todas las opciones disponibles.
    let options: [String]
    // binding a un set para guardar opcioens elegidas
    @Binding var selections: Set<String>

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.textSecondary)
                .padding(.leading)
            
            //lazyvgrid es un tipo de cuadricula que adapta el numero de columnas al tamano disponible
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        //logica para anadir o quitar seleccion
                        if selections.contains(option) {
                            selections.remove(option)
                        } else {
                            selections.insert(option)
                        }
                    }) {
                        Text(option)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selections.contains(option) ? Color.primaryBlue : Color.gray.opacity(0.15))
                            .foregroundColor(selections.contains(option) ? .white : .textPrimary)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}

// Vista previa para probar el componente ia
struct MultiSelectPickerComponent_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        let impacts = ["Robo de Identidad", "Pérdida Financiera", "Malware en Dispositivo", "Riesgo Legal"]
        @State private var selectedImpacts: Set<String> = ["Pérdida Financiera"]
        
        var body: some View {
            // --- CORRECCIÓN AQUÍ ---
            // Se ha cambiado 'selection:' por 'selections:' para que coincida
            // con el nombre de la propiedad en el componente.
            MultiSelectPickerComponent(
                title: "Impactos Potenciales",
                options: impacts,
                selections: $selectedImpacts
            )
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}

