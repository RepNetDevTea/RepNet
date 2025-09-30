//
//  HomeScreen.swift
//  RegistroUsuario452
//
//  Created by José Molina on 09/09/25.
//

import SwiftUI

struct HomeScreen: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    var body: some View {
        NavigationStack{
            TabView{
                Tab{
                    NavigationStack{
                        Text("Página de listado de Incidencias")
                        
                    }
                }label:{
                    Label("Incidencias", systemImage:"house.and.flag")
                }
                Tab{
                    NavigationStack{
                        Text("Página estadisticas")
                        
                    }
                }label:{
                    Label("Estadisticas", systemImage:"list.dash.header.rectangle")
                }
                Tab{
                    NavigationStack{
                        
                            Text("Página perfil del usuario")
                            ProfileView()
                            Button("Salir de la sesión"){
                                TokenStorage.delete(identifier: "accessToken")
                                TokenStorage.delete(identifier: "refreshToken")
                                isLoggedIn = false
                            }
                        
                        
                    }
                }label:{
                    Label("Perfil", systemImage:"person.crop.circle")
                }
            }
        }
    }
}

#Preview {

        HomeScreen()

    
}
