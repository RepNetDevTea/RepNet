//
//  AppInfoView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//


import SwiftUI

struct AppInfoView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Release notes")
                            .font(.title).bold()
                        
                        VStack(alignment: .leading) {
                            Text("20 septiembre 2025")
                            Text("Versión: 1.2")
                        }
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a lacinia odio. Sed luctus ut diam quis gravida. Donec venenatis placerat malesuada. Aliquet ac odio scelerisque, dignissim nulla et leo ornare venenatis. Morbi at interdum quam, eu pharetra nunc.")
                            .font(.body)
                    }
                    .padding(30)
                    .background(Color.textFieldBackground)
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("App Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        AppInfoView()
    }
}