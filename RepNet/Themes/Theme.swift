//
//  Theme.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

//centralizar los colores de la app de esta manera da mas facilidad si se decide de cambiar un color en especifico
//es un poco parecido a hacer tus colores en Tailwind
extension Color {
    //---------colores para el cuerpo de la app-------- anadir nuevos aqui
    static let appBackground = Color(UIColor.systemGray6)
    static let primaryBlue = Color(red: 0.22, green: 0.51, blue: 0.96)
    static let disabledGray = Color(UIColor.systemGray4)
    static let textFieldBackground = Color.white
    static let textPrimary = Color.black
    static let textSecondary = Color.gray
    static let textLink = Color(red: 0.22, green: 0.51, blue: 0.96)
    static let errorRed = Color.red

    //----------colores de las categorias de seguridad de reportes
    static let severitySevere = Color(red: 1.0, green: 0.9, blue: 0.9); static let severitySevereText = Color.red
    static let severityHigh = Color(red: 1.0, green: 0.95, blue: 0.85); static let severityHighText = Color.orange
    static let severityMedium = Color(red: 1.0, green: 1.0, blue: 0.85); static let severityMediumText = Color.yellow
    static let severityLow = Color(red: 0.9, green: 1.0, blue: 0.9); static let severityLowText = Color.green


    
    //----------colores para las cateogrias de los reportes
    static let categoryMalware = Color(red: 0.9, green: 0.95, blue: 1.0); static let categoryMalwareText = Color.blue
    static let categoryPhishing = Color(red: 0.95, green: 0.9, blue: 1.0); static let categoryPhishingText = Color.purple
    static let categoryFraud = Color(red: 1.0, green: 0.98, blue: 0.85); static let categoryFraudText = Color(red: 0.8, green: 0.6, blue: 0.0)
    static let categorySpam = Color(red: 0.88, green: 0.98, blue: 0.98); static let categorySpamText = Color.teal
    static let categoryPrivacy = Color(red: 0.9, green: 0.95, blue: 1.0); static let categoryPrivacyText = Color.blue
    static let categoryIP = Color(red: 0.98, green: 0.95, blue: 0.92); static let categoryIPText = Color.brown
    
    //----------colores para estado de reportes
    static let statusReview = Color.orange
    static let statusAccepted = Color.green
    static let statusRejected = Color.red
    
    //-------colores para impactos de reportes
    static let impactFinancial = Color(red: 0.9, green: 1.0, blue: 0.9); static let impactFinancialText = Color.green
    static let impactPrivacy = Color(red: 0.9, green: 0.95, blue: 1.0); static let impactPrivacyText = Color.blue
    static let impactLegal = Color(red: 1.0, green: 0.95, blue: 0.85); static let impactLegalText = Color.orange
    static let impactIdentity = Color(red: 0.95, green: 0.9, blue: 1.0); static let impactIdentityText = Color.purple
    static let impactMalware = Color(red: 1.0, green: 0.9, blue: 0.9); static let impactMalwareText = Color.red
    static let impactDefault = Color(UIColor.systemGray5); static let impactDefaultText = Color(UIColor.systemGray)
}

//-------fuentes de la app 
extension Font {
    static let largeTitle = Font.system(size: 28, weight: .bold)
    static let bodyText = Font.system(size: 16)
    static let buttonFont = Font.system(size: 16, weight: .semibold)
    static let caption = Font.system(size: 12)
}
