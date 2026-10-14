//
//  SignUpStranica.swift
//  vjezbanje
//
//  Created by Kemal Beganovic on 6. 7. 2026..
//
import SwiftUI
import FirebaseAuth

struct SignUpStranica: View {
    @State private var korisnickoIme = ""
    @State private var sifra = ""
    
    @State private var porukaGreske = ""
    @State private var uspjesnoLogin = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Upisi se!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(red:0.5, green:0.4, blue:0.3))
                    .padding(.bottom, 20)
                
                Text("Korisnicko ime")
                    .foregroundStyle(.orange)
                
                TextField("", text: $korisnickoIme)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Text("Sifra")
                    .foregroundStyle(.orange)
                
                SecureField("", text: $sifra)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                
                if !porukaGreske.isEmpty {
                    Text(porukaGreske)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.vertical, 5)
                }
                
                Spacer().frame(height: 30)
                
                Button(action: {
                    Auth.auth().signIn(withEmail: korisnickoIme, password: sifra) { authResult, error in
                        if let error = error {
                            self.porukaGreske = error.localizedDescription
                        } else {
                            self.uspjesnoLogin = true
                        }
                    }
                }) {
                    Text("Prijavi se")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(25)
                }
                .navigationDestination(isPresented: $uspjesnoLogin) {
                    HomePage()
                }
                
                Spacer()
            }
            .padding(30)
        }
    }
}

#Preview {
    SignUpStranica()
}
