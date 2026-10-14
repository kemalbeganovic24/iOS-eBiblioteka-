import SwiftUI
import FirebaseDatabase

struct DodajKnjiguView: View {
    @State private var naslov = ""
    @State private var autor = ""
    @State private var broj = ""
    @State private var jezik = ""
    @State private var tkoJeUnio = ""
    @State private var odabranaVrsta = "Historija"
    @State private var poruka = ""
    
    let vrsteKnjiga = ["Poezija",
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
                       "Enciklopedija / Vodič"]
    
    var body: some View {
        VStack(spacing: 15) {
            GornjiHeader()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Izaberite vrstu knjige:").font(.headline)
                    Picker("Vrsta", selection: $odabranaVrsta) {
                        ForEach(vrsteKnjiga, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.menu)
                    .padding().background(Color(.systemGray6)).cornerRadius(10)
                    
                    Text("Unesi naziv knjige:")
                    TextField("", text: $naslov)
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    
                    Text("Autor knjige:")
                    TextField("", text: $autor)
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    
                    Text("Broj (Količina):")
                    TextField("", text: $broj).keyboardType(.numberPad)
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    
                    Text("Jezik:")
                    TextField("", text: $jezik)
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    
                    Text("Ime ko je unio knjigu:")
                    TextField("", text: $tkoJeUnio)
                        .padding().background(Color(.systemGray6)).cornerRadius(10)
                    
                    if !poruka.isEmpty {
                        Text(poruka).foregroundColor(.green).font(.caption)
                    }
                    
                    Button(action: spremiUFirebase) {
                        VStack {
                            Image(systemName: "plus").font(.title)
                            Text("Dodaj knjigu").font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(15)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
            }
        }
    }
    
    func spremiUFirebase() {
        let ref = Database.database(url: "https://ebiblioteka-28abf-default-rtdb.europe-west1.firebasedatabase.app").reference()
            let kolicina = Int(broj) ?? 1
        // Kreiramo rječnik (Dictionary) prateći točnu strukturu tvog JSON-a sa slike ("autori")
        let noviPodaci: [String: Any] = [
            "naslov": naslov,
            "autori": autor, // Ključ mora biti "autori" kako bi odgovarao tvom JSON-u
            "broj": kolicina,
            "jezik": jezik,
            "vrsta": odabranaVrsta,
            "tkoJeUnio": tkoJeUnio,
            "naStanju": kolicina > 0,
            "datumUnosa": ServerValue.timestamp()
        ]
        
        // Generira novi jedinstveni čvor u bazi kako se podaci ne bi prepisali preko indeksa 0, 1, 2...
        ref.childByAutoId().setValue(noviPodaci) { error, _ in
            DispatchQueue.main.async {
                if let error = error {
                    poruka = "Greška: \(error.localizedDescription)"
                } else {
                    poruka = "Knjiga uspješno dodana!"
                    naslov = ""; autor = ""; broj = ""; jezik = ""; tkoJeUnio = ""
                }
            }
        }
    }
}
