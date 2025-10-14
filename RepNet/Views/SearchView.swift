//
//  SearchView.swift
//  RepNet
//
//  Created by Angel Bosquez on 09/10/25.
//


import SwiftUI

// esta es la vista para la pestana de "busqueda".
// su diseno es "dirigido por estado": usa un `switch` para cambiar la interfaz
// completamente segun el estado (`.initial`, `.loading`, `.success`, etc.) del viewmodel.

// -- componentes utilizados --
// - searchbarcomponent
// - sitecardcomponent
// - searchplaceholderview (vista auxiliar local)
struct SearchView: View {
    // esta vista crea y es duena de su propio viewmodel, ya que el estado de la busqueda
    // es local y no necesita persistir si se cambia de pestana.
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("busqueda")
                    .font(.largeTitle).bold()
                    .padding([.horizontal, .top])
                
                SearchBarComponent(text: $viewModel.searchQuery, placeholder: "buscar por pagina o reporte...")
                    .padding(.horizontal)
                
                // --- cerebro de la interfaz ---
                // este `switch` lee el estado del viewmodel y dibuja la interfaz correspondiente.
                // esto hace que la logica sea muy clara y facil de seguir.
                switch viewModel.state {
                case .initial:
                    // estado inicial: muestra un mensaje de bienvenida.
                    SearchPlaceholderView(icon: "magnifyingglass", text: "busca un sitio web o reporte para ver los resultados.")
                case .loading:
                    // estado de carga: muestra un spinner.
                    ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let sites):
                    // estado de exito: muestra la lista de resultados.
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(sites) { site in
                                SiteCardComponent(site: site)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                case .empty:
                    // estado vacio: no se encontraron resultados.
                    SearchPlaceholderView(icon: "questionmark.folder", text: "no se encontraron resultados para \"\(viewModel.searchQuery)\".")
                case .error(let message):
                    // estado de error: muestra el mensaje de error.
                    SearchPlaceholderView(icon: "exclamationmark.triangle", text: message, isError: true)
                }
                
                Spacer()
            }
            .background(Color.appBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .onAppear {
                // cuando la vista aparece, no carga datos, sino que le dice al viewmodel
                // que empiece a "escuchar" los cambios en la barra de busqueda para la busqueda reactiva.
                viewModel.setupSearch()
            }
        }
    }
}


// -- vistas auxiliares --

// un componente de vista reutilizable para mostrar los diferentes mensajes de
// estado (inicial, vacio, error) con un icono y texto.
private struct SearchPlaceholderView: View {
    let icon: String
    let text: String
    var isError: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(isError ? .red : .textSecondary)
            Text(text)
                .font(.headline)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// mark: - preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
