//
//  SuccessBannerComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct SuccessBannerComponent: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.green)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
            .cornerRadius(8)
    }
}
//hola emi we
