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
    let backgroundColor: Color
    let textColor: Color

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
}

#Preview {
    VStack(spacing: 10) {
        TagComponent(text: "Severa", backgroundColor: .severitySevere, textColor: .severitySevereText)
        TagComponent(text: "Malware", backgroundColor: .categoryMalware, textColor: .categoryMalwareText)
        TagComponent(text: "Phishing", backgroundColor: .categoryPhishing, textColor: .categoryPhishingText)
    }
    .padding()
}
