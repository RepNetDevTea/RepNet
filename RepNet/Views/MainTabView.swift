//
//  MainTabView.swift
//  RepNet
//
//  Created by Angel Bosquez on 28/09/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // --- Pestaña 1: Mis Reportes ---
            NavigationView {
                MyReportsView()
            }
            .tabItem {
                Image(systemName: "doc.text.fill")
                Text("Mis reportes")
            }
            
            // --- Pestaña 2: Reportes Públicos ---
            NavigationView {
                PublicReportsView()
            }
            .tabItem {
                Image(systemName: "globe")
                Text("Re. Públicos")
            }
            
            // --Nueva pestaña 3, busqueda, sitios, etc ---
            NavigationView{
                
            }
            .tabItem{
                Image(systemName: "magnifyingglass")
                Text("Busqueda")
            }
            
            // --- Pestaña 4 antes  3: Mi Cuenta ) ---
            NavigationView {
                AccountView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Mi cuenta")
            }
        }
        .accentColor(.primaryBlue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationManager())
}
