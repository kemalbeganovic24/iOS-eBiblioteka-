//
//  SplashScreenView.swift
//  vjezbanje
//
//  Created by Kemal Beganovic on 30. 9. 2026..
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "books.vertical.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                Text("eBiblioteka")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    self.scale = 1.0
                    self.opacity = 1.0
                }
            }
        }
    }
}
