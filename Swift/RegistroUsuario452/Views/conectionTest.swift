//
//  conectionTest.swift
//  RegistroUsuario452
//
//  Created by Usuario on 01/10/25.
//

import SwiftUI

struct conectionTest: View {
    @State private var respuesta = "Presiona el botón para probar"

        var body: some View {
            VStack(spacing: 20) {
                Text(respuesta)
                    .padding()
                    .multilineTextAlignment(.center)

                Button("Probar API") {
                    probarAPI()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }

        func probarAPI() {
            guard let url = URL(string: "http://10.48.211.6:3000/users") else {
                respuesta = "URL inválida"
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        respuesta = "❌ Error: \(error.localizedDescription)"
                    } else if let data = data, let texto = String(data: data, encoding: .utf8) {
                        respuesta = "✅ Respuesta: \(texto)"
                    } else {
                        respuesta = "⚠️ Sin datos"
                    }
                }
            }.resume()
        }
}

#Preview {
    conectionTest()
}
