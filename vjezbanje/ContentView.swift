//
//  ContentView.swift
//  vjezbanje
//
//  Created by Kemal Beganovic on 30. 6. 2026..
//

import SwiftUI
import SwiftData
import FirebaseCore



struct ContentView: View {
    var body: some View{
        NavigationStack{
            
        
            ZStack{
                Image("pozadina")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea() // ignoreSafeArea prekriva i gdje je sat i bateriju tj. gornji dio telefona
                VStack(spacing:30){
                    Spacer()
                    Image("BZK")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170,height: 170)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    
                    Text("eBiblioteka")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    
                        NavigationLink(destination: HomePage()){
                            
                            
                            Text("Započni")
                                .font(.headline)
                                .foregroundStyle(.blue)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        }
                        .padding(.horizontal,40)
                        .padding(.bottom,20)
                    }
                    
                }
            }
        }
    }

    
   

    


#Preview {
    ContentView()
}
