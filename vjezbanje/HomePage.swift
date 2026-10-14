//
//  HomePage.swift
//  vjezbanje
//
//  Created by Kemal Beganovic on 6. 7. 2026..
//

import SwiftUI

struct HomePage: View {
    @State private var trenutniTab = 0
    
    var body: some View {
        TabView(selection: $trenutniTab) {
            HomeStranicaView()
                .tabItem { Image(systemName: "house.fill") }
                .tag(0)
            
            ListaKnjigaView()
                .tabItem { Image(systemName: "list.bullet.rectangle.fill") }
                .tag(1)
            
            DodajKnjiguView()
                .tabItem { Image(systemName: "plus.app.fill") }
                .tag(2)
            
            SearchKnjigaView()
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(3)
        }
        .accentColor(.orange)
        .navigationBarBackButtonHidden(true) // Sakriva gumb "Nazad" jer smo se uspješno prijavili
    }
}

// ZAJEDNIČKI HEADER KOJI VUČE PODATKE IZ FIREBASEA
struct GornjiHeader: View {
    @StateObject private var korisnikVM = KorisnikViewModel()
    
    var body: some View {
        HStack {
            Image("BZK")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text("E-Biblioteka")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            
        }
        .padding(.horizontal)
        
    }
}

// Privremeni izgled za prvu karticu (Home)
struct HomeStranicaView: View {
    var body: some View {
        VStack {
            GornjiHeader()
            Spacer()
            Text("Dobrodošli u digitalnu biblioteku Bošnjačke zajednice općinsko društvo Vitez!").font(.headline)
            Spacer()
        }
    }
}
