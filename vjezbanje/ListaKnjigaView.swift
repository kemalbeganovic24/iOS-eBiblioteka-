import SwiftUI
import FirebaseDatabase

struct ListaKnjigaView: View {
    @State private var knjige = [Knjiga]()
    @State private var odabranaVrstaFiltriranja = "Sve"
    @State private var odabranaKnjiga: Knjiga? = nil
    
    let vrsteKnjiga = [
        "Sve",
        "Poezija",
        "Proza",
        "Drama",
        "Historija / Dokumentaristika",
        "Pripovijetke / Novele",
        "Roman",
        "Eseji i književna kritika",
        "Lingvistika / Pravopis",
        "Časopis / Godišnjak",
        "Monografija",
        "Putopis",
        "Biografija / Memoari",
        "Zbirke radova",
        "Usmena književnost",
        "Enciklopedija / Vodič",
        "Općenito"
    ]
    
    var filtriraneKnjige: [Knjiga] {
        if odabranaVrstaFiltriranja == "Sve" {
            return knjige
        } else {
            return knjige.filter { $0.vrsta.localizedCaseInsensitiveContains(odabranaVrstaFiltriranja) }
        }
    }
    
    var body: some View {
        VStack {
            GornjiHeader()
            
            VStack(spacing: 5) {
                Text("Filtriraj po vrsti knjige:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Picker("Vrsta", selection: $odabranaVrstaFiltriranja) {
                    ForEach(vrsteKnjiga, id: \.self) { vrsta in
                        Text(vrsta).tag(vrsta)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            List(filtriraneKnjige) { knjiga in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(knjiga.naslov)
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        
                        Text(knjiga.vrsta.isEmpty ? "Općenito" : knjiga.vrsta)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(5)
                    }
                    
                    Text("Autor: \(knjiga.autor)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Količina: \(knjiga.broj)")
                        Text("•")
                        Text("Jezik: \(knjiga.jezik)")
                        Text("•")
                        Text("Unio: \(knjiga.tkoJeUnio)")
                        
                        Spacer()
                        
                        Text(knjiga.broj > 0 ? "DOSTUPNO" : "NIJE DOSTUPNO")
                            .font(.caption2).fontWeight(.bold)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(knjiga.broj > 0 ? Color.green : Color.red)
                            .foregroundColor(.white).cornerRadius(10)
                    }
                    .font(.caption).foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture {
                    odabranaKnjiga = knjiga
                }
            }
            .listStyle(.plain)
            .onAppear(perform: ucitajKnjigeIzKorijena)
        }
        .sheet(item: $odabranaKnjiga) { knjiga in
            KnjigaDetaljiView(knjiga: knjiga)
        }
    }
    
    func ucitajKnjigeIzKorijena() {
        let dbURL = "https://ebiblioteka-28abf-default-rtdb.europe-west1.firebasedatabase.app"
        let ref = Database.database(url: dbURL).reference()
        
        ref.observe(.value, with: { snapshot in
            print("--- FIREBASE ODGOVOR PRIMLJEN ---")
            guard snapshot.exists() else {
                print("Baza je prazna ili čvor ne postoji.")
                return
            }
            
            // Provjera da li su knjige direktno u korijenu ili unutar "knjige" čvora
            var targetSnapshot = snapshot
            if snapshot.hasChild("knjige") {
                targetSnapshot = snapshot.childSnapshot(forPath: "knjige")
            }
            
            var ucitaneKnjige = [Knjiga]()
            
            // Prolazak kroz sve elemente unutar Firebase čvora
            for child in targetSnapshot.children.allObjects as? [DataSnapshot] ?? [] {
                guard let v = child.value as? [String: Any] else { continue }
                
                let kljuc = child.key
                let naslov = v["naslov"] as? String ?? (v["title"] as? String ?? "Nepoznat naslov")
                let broj = v["broj"] as? Int ?? (v["brojKnjigaDostupno"] as? Int ?? 0)
                let jezik = v["jezik"] as? String ?? "Bosanski"
                let tkoJeUnio = v["tkoJeUnio"] as? String ?? "Sistem"
                let coverUrl = v["cover"] as? String ?? (v["coverUrl"] as? String)
                
                let urednici = v["urednici"] as? String ?? (v["urednik"] as? String)
                let isbn = v["isbn"] as? String ?? (v["ISBN"] as? String)
                let isbnk = v["isbnk"] as? String ?? (v["ISBNK"] as? String)
                let isbnun = v["isbnun"] as? String ?? (v["ISBNUN"] as? String)
                let tip = v["tip"] as? String ?? (v["Tip"] as? String)
                let kolekcija = v["kolekcija"] as? String ?? (v["Kolekcija"] as? String)
                let izdanje = v["izdanje"] as? String ?? (v["Izdanje"] as? String)
                let izdavac = v["izdavac"] as? String ?? (v["Izdavac"] as? String ?? (v["izdavač"] as? String))
                let issn = v["issn"] as? String ?? (v["ISSN"] as? String)
                let cobiss = v["cobissbihId"] as? String ?? (v["COBISSBIH-ID"] as? String ?? (v["cobiss"] as? String))
                let ciphr = v["ciphr"] as? String ?? (v["CIPHR"] as? String)
                
                let vrsta = v["žanr"] as? String ??
                            (v["vrsta"] as? String ??
                            (v["kategorija"] as? String ?? "Općenito"))
                
                let tempDatum = v["datumUnosa"] as? Double
                let datum = tempDatum != nil ? Date(timeIntervalSince1970: tempDatum!) : Date()
                
                var autorIme = "Nepoznat autor"
                if let autoriPolje = v["autori"] as? String ?? (v["autor"] as? String) {
                    autorIme = autoriPolje
                } else if let autoriNiz = v["autori"] as? [String] {
                    autorIme = autoriNiz.joined(separator: ", ")
                }
                
                let novaKnjiga = Knjiga(
                    id: kljuc,
                    naslov: naslov,
                    autor: autorIme,
                    urednici: urednici,
                    isbn: isbn,
                    isbnk: isbnk,
                    isbnun: isbnun,
                    tip: tip,
                    kolekcija: kolekcija,
                    broj: broj,
                    izdanje: izdanje,
                    izdavac: izdavac,
                    jezik: jezik,
                    issn: issn,
                    cobissbihId: cobiss,
                    ciphr: ciphr,
                    vrsta: vrsta,
                    tkoJeUnio: tkoJeUnio,
                    datumUnosa: datum,
                    naStanju: broj > 0,
                    coverUrl: coverUrl
                )
                
                ucitaneKnjige.append(novaKnjiga)
            }
            
            print("Uspješno učitano knjiga: \(ucitaneKnjige.count)")
            
            DispatchQueue.main.async {
                self.knjige = ucitaneKnjige.sorted { $0.naslov.lowercased() < $1.naslov.lowercased() }
            }
        }, withCancel: { error in
            print("FIREBASE GREŠKA PRISTUPA: \(error.localizedDescription)")
        })
    }
}
