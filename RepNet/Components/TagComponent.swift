//
//  TagComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//
//Dropdown picker component depende de este componente

import SwiftUI

struct TagComponent: View {
    let text: String
    
    // Propiedades privadas para guardar el estilo
    private let backgroundColor: Color
    private let textColor: Color

    // El inicializador ahora es mucho más simple. Solo necesita el texto.
    init(text: String) {
        self.text = text
        // Llama a nuestra función auxiliar para determinar los colores correctos.
        let style = Self.getStyle(for: text)
        self.backgroundColor = style.backgroundColor
        self.textColor = style.textColor
    }

    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(20)
    }
    
    // --- LÓGICA DE ESTILO CENTRALIZADA ---
    // Esta función estática actúa como un "diccionario de estilos".
    // Le das un texto y te devuelve los colores correctos desde Theme.swift.
    private static func getStyle(for text: String) -> (backgroundColor: Color, textColor: Color) {
        switch text {
        // Severidades
        case "Severa": return (.severitySevere, .severitySevereText)
        case "Alta", "High": return (.severityHigh, .severityHighText)
        case "Media", "Medium": return (.severityMedium, .severityMediumText)
        case "Baja", "Low": return (.severityLow, .severityLowText)
            
        // Categorías
        case "Phishing": return (.categoryPhishing, .categoryPhishingText)
        case "Malware": return (.categoryMalware, .categoryMalwareText)
        case "Fraude": return (.categoryFraud, .categoryFraudText)
        case "Spam": return (.categorySpam, .categorySpamText)
        case "Violación de privacidad": return (.categoryPrivacy, .categoryPrivacyText)
        case "Falsificación/Propiedad intelectual": return (.categoryIP, .categoryIPText)
            
        // --- NUEVOS CASOS PARA IMPACTOS ---
        case "Robo de credenciales", "Robo de identidad":
            return (.impactIdentity, .impactIdentityText)
        case "Pérdida financiera":
            return (.impactFinancial, .impactFinancialText)
        case "Pérdida de la privacidad":
            return (.impactPrivacy, .impactPrivacyText)
        case "Infección de malware":
            return (.impactMalware, .impactMalwareText)
        case "Riesgo legal":
            return (.impactLegal, .impactLegalText)
            
        // Default para cualquier otro texto
        default: return (.impactDefault, .impactDefaultText)
        }
    }
}

// La vista previa ahora usa el nuevo inicializador simple. ¡Mucho más limpio!
// He añadido un impacto a la vista previa para que puedas verlo.
struct TagComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            TagComponent(text: "Severa")
            TagComponent(text: "Malware")
            TagComponent(text: "Fraude")
            TagComponent(text: "Pérdida financiera") // Nuevo ejemplo
        }
        .padding()
    }
}
