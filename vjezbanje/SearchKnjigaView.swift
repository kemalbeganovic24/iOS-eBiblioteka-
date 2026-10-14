import SwiftUI
import FirebaseDatabase

struct SearchKnjigaView: View {
    @State private var sveKnjige = [Knjiga]()
    @State private var pojamZaPretragu = ""
    
    var filtriraneKnjige: [Knjiga] {
        if pojamZaPretragu.isEmpty {
            return sveKnjige
        } else {
            return sveKnjige.filter { knjiga in
                knjiga.naslov.localizedCaseInsensitiveContains(pojamZaPretragu) ||
                knjiga.autor.localizedCaseInsensitiveContains(pojamZaPretragu)
            }
        }
    }
    
    var body: some View {
        VStack {
            GornjiHeader()
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Pretraži Knjigu", text: $pojamZaPretragu)
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .padding(.horizontal)
            
            List(filtriraneKnjige) { knjiga in
                HStack(alignment: .top) {
                    Image(systemName: "bookmark.circle.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                        .padding(.top, 2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(knjiga.naslov)
                            .fontWeight(.semibold)
                        
                        Text("Autor: \(knjiga.autor)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        // DODANO: Ispis dodatnih informacija (Količina, Jezik, Unio)
                        HStack(spacing: 6) {
                            Text("Kol: \(knjiga.broj)")
                            Text("•")
                            Text("Jezik: \(knjiga.jezik)")
                            Text("•")
                            Text("Unio: \(knjiga.tkoJeUnio)")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(knjiga.broj > 0 ? "Dostupno" : "Nije dostupno")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(knjiga.broj > 0 ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .foregroundColor(knjiga.broj > 0 ? .green : .red)
                        .cornerRadius(5)
                }
                .padding(.vertical, 4)
            }
            .listStyle(.plain)
            .onAppear(perform: ucitajSveKnjigeIzKorijena)
        }
    }
    
    func ucitajSveKnjigeIzKorijena() {
        let ref = Database.database(url: "https://ebiblioteka-28abf-default-rtdb.europe-west1.firebasedatabase.app").reference()
        
        ref.observe(.value) { snapshot, _ in
            var ucitaneKnjige = [Knjiga]()
            
            if let nizKnjiga = snapshot.value as? [[String: Any]] {
                for (indeks, vrijednost) in nizKnjiga.enumerated() {
                    let naslov = vrijednost["naslov"] as? String ?? ""
                    let broj = vrijednost["broj"] as? Int ?? 0
                    let jezik = vrijednost["jezik"] as? String ?? ""
                    let tkoJeUnio = vrijednost["tkoJeUnio"] as? String ?? "Sistem"
                    let vrsta = vrijednost["vrsta"] as? String ?? (vrijednost["kategorija"] as? String ?? "Općenito")
                    
                    let tempDatum = vrijednost["datumUnosa"] as? Double
                    let datum = tempDatum != nil ? Date(timeIntervalSince1970: tempDatum!) : Date()
                    
                    var autorIme = ""
                    if let autoriPolje = vrijednost["autori"] as? String {
                        autorIme = autoriPolje
                    } else if let autoriNiz = vrijednost["autori"] as? [String] {
                        autorIme = autoriNiz.joined(separator: ", ")
                    }
                    
                    let novaKnjiga = Knjiga(
                        id: String(indeks),
                        naslov: naslov,
                        autor: autorIme,
                        broj: broj,
                        jezik: jezik,
                        vrsta: vrsta,
                        tkoJeUnio: tkoJeUnio,
                        datumUnosa: datum,
                        naStanju: broj > 0
                    )
                    ucitaneKnjige.append(novaKnjiga)
                }
            } else if let rjecnikKnjiga = snapshot.value as? [String: Any] {
                for (kljuc, podaci) in rjecnikKnjiga {
                    guard let vrijednost = podaci as? [String: Any] else { continue }
                    let naslov = vrijednost["naslov"] as? String ?? ""
                    let broj = vrijednost["broj"] as? Int ?? 0
                    let jezik = vrijednost["jezik"] as? String ?? ""
                    let tkoJeUnio = vrijednost["tkoJeUnio"] as? String ?? "Sistem"
                    let vrsta = vrijednost["vrsta"] as? String ?? (vrijednost["kategorija"] as? String ?? "Općenito")
                    
                    let tempDatum = vrijednost["datumUnosa"] as? Double
                    let datum = tempDatum != nil ? Date(timeIntervalSince1970: tempDatum!) : Date()
                    
                    var autorIme = ""
                    if let autoriPolje = vrijednost["autori"] as? String {
                        autorIme = autoriPolje
                    } else if let autoriNiz = vrijednost["autori"] as? [String] {
                        autorIme = autoriNiz.joined(separator: ", ")
                    }
                    
                    let novaKnjiga = Knjiga(
                        id: kljuc,
                        naslov: naslov,
                        autor: autorIme,
                        broj: broj,
                        jezik: jezik,
                        vrsta: vrsta,
                        tkoJeUnio: tkoJeUnio,
                        datumUnosa: datum,
                        naStanju: broj > 0
                    )
                    ucitaneKnjige.append(novaKnjiga)
                }
            }
            
            let sortiraneKnjige = ucitaneKnjige.sorted { $0.naslov.lowercased() < $1.naslov.lowercased() }
            
            DispatchQueue.main.async {
                self.sveKnjige = sortiraneKnjige
            }
        }
    }
}
