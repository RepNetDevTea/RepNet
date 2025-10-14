//
//  ReportDetailView.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//


import SwiftUI

// esta es la vista de "detalle de reporte". muestra toda la informacion
// de un solo reporte y permite al usuario votar.

// -- componentes utilizados --
// - tagcomponent
// - votecomponent
// - inforow (vista auxiliar local)
struct ReportDetailView: View {
    
    // se crea el viewmodel aqui. se usa `@stateobject` para que persista mientras la vista exista.
    @StateObject private var viewModel: ReportDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // el inicializador de la vista recibe un `report`.
    // luego, usa ese `report` para crear e inicializar su propio `reportdetailviewmodel`.
    // la sintaxis `_viewmodel = stateobject(...)` es la forma correcta de hacer esto.
    init(report: Report) {
        _viewModel = StateObject(wrappedValue: ReportDetailViewModel(report: report))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                
                // --- tarjeta principal con la informacion ---
                VStack(alignment: .leading, spacing: 20) {
                    
                    // --- fila superior (titulo y severidad) ---
                    HStack(alignment: .top) {
                        Text(viewModel.report.title)
                            .font(.title).bold()
                        Spacer()
                        TagComponent(text: viewModel.report.severity)
                    }
                    
                    // --- subtitulo ---
                    Text("reporte de sitio \"\(viewModel.report.url)\" por el usuario \"\(viewModel.report.user.username)\"")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                        .padding(.bottom, 10)
                    
                    Divider()
                    
                    // --- informacion principal (id, fecha, url) ---
                    InfoRow(label: "id:", value: viewModel.report.displayId)
                    InfoRow(label: "fecha:", value: viewModel.report.date)
                    InfoRow(label: "url:", value: viewModel.report.url)
                    
                    Divider()
                    
                    // --- descripcion y evidencias ---
                    InfoRow(label: "categorias:") {
                        HStack { TagComponent(text: viewModel.report.category) }
                    }
                    InfoRow(label: "descripcion:", value: viewModel.report.description)
                    
                    InfoRow(label: "archivo(s):") {
                        // placeholder para la imagen de evidencia.
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 200)
                            .overlay(Text("vista previa de imagen").foregroundColor(.textSecondary))
                    }
                }
                .padding()
                .background(Color.textFieldBackground)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                
                // --- seccion de votacion ---
                // se muestra solo si el reporte tiene una puntuacion.
                if viewModel.report.voteScore != nil {
                    // --- creacion de bindings ---
                    // `votecomponent` necesita bindings (`$`), pero el `report` dentro del viewmodel no es
                    // directamente bindable. creamos estos bindings "falsos" o "de solo lectura".
                    // el `get` le da el valor actual. el `set` esta vacio para que `votecomponent` no pueda
                    // modificar el estado directamente. esta obligado a usar `onupvote`/`ondownvote`,
                    // manteniendo toda la logica dentro del viewmodel.
                    let scoreBinding = Binding<Int>(get: { viewModel.report.voteScore ?? 0 }, set: { _ in })
                    let statusBinding = Binding<UserVoteStatus?>(get: { viewModel.report.userVoteStatus }, set: { _ in })
                    
                    VoteComponent(
                        score: scoreBinding,
                        voteStatus: statusBinding,
                        onUpvote: { viewModel.handleUpvote() },
                        onDownvote: { viewModel.handleDownvote() }
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationBarHidden(false) // se muestra la barra de navegacion para el boton de "atras".
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // se deja el titulo de la barra de navegacion vacio para un look mas limpio.
                Text("")
            }
        }
    }
}

// -- vistas auxiliares --

// un componente de vista reutilizable para mostrar una fila de informacion con una etiqueta y un valor.
// es generico y tiene dos inicializadores para ser mas flexible.
private struct InfoRow<Content: View>: View {
    let label: String
    var content: Content?

    // este `init` es para cuando el valor es un simple string.
    init(label: String, value: String) where Content == Text {
        self.label = label
        self.content = Text(value).font(.body)
    }
    
    // este `init` es mas avanzado y permite pasar cualquier vista como contenido
    // (ej. un `hstack` con varios `tagcomponent`).
    init(label: String, @ViewBuilder content: @escaping () -> Content) {
        self.label = label
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.textSecondary)
            content
        }
    }
}

// mark: - preview

struct ReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let sampleUser = UserInReportDTO(username: "agbb05")
            let sampleReport = Report(displayId: "0987654321", title: "reporte nombre", date: "6 septiembre 2025", url: "https://www.sus.com.mx", description: "descripcion de la amenaza o problema detectado", category: "otro", severity: "severa", user: sampleUser, createdAt: Date(), voteScore: 566, userVoteStatus: .upvoted)
            ReportDetailView(report: sampleReport)
        }
    }
}
