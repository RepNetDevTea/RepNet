//
//  StatusIndicatorComponent.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//


import SwiftUI

struct StatusIndicatorComponent: View {
    let statusText: String
    let statusColor: Color

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(statusText)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        StatusIndicatorComponent(statusText: "Revisión", statusColor: .statusReview)
        StatusIndicatorComponent(statusText: "Aceptado", statusColor: .statusAccepted)
        StatusIndicatorComponent(statusText: "Rechazado", statusColor: .statusRejected)
    }
    .padding()
}
