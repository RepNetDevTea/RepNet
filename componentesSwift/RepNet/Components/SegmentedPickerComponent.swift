//
//  SegmentedPickerComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//


import SwiftUI

struct SegmentedPickerComponent: View {
    let options: [String]
    @Binding var selectedOption: String
    
    @Namespace private var animation

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation(.spring()) {
                            selectedOption = option
                        }
                    }) {
                        Text(option)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .foregroundColor(selectedOption == option ? .primaryBlue : .textSecondary)
                            .background(
                                ZStack {
                                    if selectedOption == option {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .matchedGeometryEffect(id: "picker", in: animation)
                                            .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                                    }
                                }
                            )
                    }
                }
            }
            .padding(5)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(16)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selection = "Revisión"
        let options = ["Todos", "Revisión", "Aceptados", "Rechazados"]
        
        var body: some View {
            SegmentedPickerComponent(options: options, selectedOption: $selection)
                .padding()
        }
    }
    return PreviewWrapper()
}
