//
//  Theme.swift
//  RegistroUsuario452
//
//  Created by Usuario on 01/10/25.
//


//
//  Theme.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

extension Color {
    
    static let appBackground = Color(UIColor.systemGray6)
    static let primaryBlue = Color(red: 0.22, green: 0.51, blue: 0.96)
    static let disabledGray = Color(UIColor.systemGray4)
    static let textFieldBackground = Color.white
    static let textPrimary = Color.black
    static let textSecondary = Color.gray
    static let textLink = Color(red: 0.22, green: 0.51, blue: 0.96)
    static let errorRed = Color.red

  
    
    //-----colores para estados de severidad---
    static let severitySevere = Color(red: 1.0, green: 0.9, blue: 0.9)
    static let severitySevereText = Color.red
    static let severityHigh = Color(red: 1.0, green: 0.95, blue: 0.85)
    static let severityHighText = Color.orange
    static let severityMedium = Color(red: 1.0, green: 1.0, blue: 0.85)
    static let severityMediumText = Color.yellow
    
    //----cateategoría---
    static let categoryMalware = Color(red: 0.9, green: 0.95, blue: 1.0)
    static let categoryMalwareText = Color.blue
    static let categoryPhishing = Color(red: 0.95, green: 0.9, blue: 1.0)
    static let categoryPhishingText = Color.purple
    
    //---estado del reporte
    static let statusReview = Color.orange
    static let statusAccepted = Color.green
    static let statusRejected = Color.red
}

//---fuentes----
extension Font {
    static let largeTitle = Font.system(size: 28, weight: .bold)
    static let bodyText = Font.system(size: 16)
    static let buttonFont = Font.system(size: 16, weight: .semibold)
    static let caption = Font.system(size: 12)
}

