import SwiftUI

struct KnjigaDetaljiView: View {
    let knjiga: Knjiga
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Bijela kartica sa podacima
                    VStack(spacing: 16) {
                        
                        // 1. Slika naslovnice (Cover) sa Supabase-a
                        if let coverString = knjiga.coverUrl, let url = URL(string: coverString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(height: 180)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 220)
                                        .cornerRadius(8)
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                case .failure:
                                    zamjenskaSlika
                                @unknown default:
                                    zamjenskaSlika
                                }
                            }
                        } else {
                            zamjenskaSlika
                        }

                        // 2. Naslov Knjige
                        Text(knjiga.naslov)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.88, green: 0.43, blue: 0.15)) // Narandžasta boja sa Figme
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)

                        // 3. Autori
                        Text("Autori: \(knjiga.autor)")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        VStack(alignment: .leading, spacing: 6) {
                            
                            if let urednici = knjiga.urednici, !urednici.isEmpty {
                                RedakTeksta(naziv: "Urednici", vrijednost: urednici)
                            }
                            if let isbn = knjiga.isbn, !isbn.isEmpty {
                                RedakTeksta(naziv: "ISBN", vrijednost: isbn)
                            }
                            if let isbnk = knjiga.isbnk, !isbnk.isEmpty {
                                RedakTeksta(naziv: "ISBNK", vrijednost: isbnk)
                            }
                            if let isbnun = knjiga.isbnun, !isbnun.isEmpty {
                                RedakTeksta(naziv: "ISBNUN", vrijednost: isbnun)
                            }
                            if let tip = knjiga.tip, !tip.isEmpty {
                                RedakTeksta(naziv: "Tip", vrijednost: tip)
                            }
                            if let kolekcija = knjiga.kolekcija, !kolekcija.isEmpty {
                                RedakTeksta(naziv: "Kolekcija", vrijednost: kolekcija)
                            }
                            
                            RedakTeksta(naziv: "Broj Knjiga Dostupno", vrijednost: "\(knjiga.broj)")
                            
                            if let izdanje = knjiga.izdanje, !izdanje.isEmpty {
                                RedakTeksta(naziv: "Izdanje", vrijednost: izdanje)
                            }
                            if let izdavac = knjiga.izdavac, !izdavac.isEmpty {
                                RedakTeksta(naziv: "Izdavac", vrijednost: izdavac)
                            }
                            
                            RedakTeksta(naziv: "Jezik", vrijednost: knjiga.jezik)
                            
                            if let issn = knjiga.issn, !issn.isEmpty {
                                RedakTeksta(naziv: "ISSN", vrijednost: issn)
                            }
                            if let cobiss = knjiga.cobissbihId, !cobiss.isEmpty {
                                RedakTeksta(naziv: "COBISSBIH-ID", vrijednost: cobiss)
                            }
                            if let ciphr = knjiga.ciphr, !ciphr.isEmpty {
                                RedakTeksta(naziv: "CIPHR", vrijednost: ciphr)
                            }
                            
                            RedakTeksta(naziv: "Žanr", vrijednost: knjiga.vrsta.isEmpty ? "Općenito" : knjiga.vrsta)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 10)

                        // 4. Zeleno dugme / Oznaka Dostupno (kao na Figmi)
                        Text(knjiga.broj > 0 ? "DOSTUPNO" : "NIJE DOSTUPNO")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(knjiga.broj > 0 ? Color(red: 0.2, green: 0.85, blue: 0.4) : Color.red)
                            .cornerRadius(25)
                            .padding(.top, 15)
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                    .padding()
                }
            }
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
            .navigationTitle("Detalji o knjizi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zatvori") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var zamjenskaSlika: some View {
        Image(systemName: "book.closed.fill")
            .resizable()
            .scaledToFit()
            .frame(height: 120)
            .foregroundColor(.gray.opacity(0.4))
            .padding()
    }
}

// Pomagalo za ispis linija teksta
struct RedakTeksta: View {
    let naziv: String
    let vrijednost: String

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Text("\(naziv):")
                .foregroundColor(.gray)
            Text(vrijednost)
                .foregroundColor(.secondary)
        }
        .font(.system(size: 15))
    }
}
