import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class KorisnikViewModel: ObservableObject {
    @Published var imeKorisnika: String = "Učitavanje..."
    
    init() {
        dohvatiImePrijavljenogKorisnika()
    }
    
    func dohvatiImePrijavljenogKorisnika() {
        guard let trenutniUser = Auth.auth().currentUser else {
            self.imeKorisnika = "Gost"
            return
        }
        
        // Privremeno prikaži dio emaila prije "@" ako nemamo bazu u Firestoreu
        if let email = trenutniUser.email {
            self.imeKorisnika = email.components(separatedBy: "@").first ?? "Korisnik"
        }
        
        // Ako u Firestoreu imaš kolekciju "korisnici", povući će pravo ime
        let db = Firestore.firestore()
        db.collection("korisnici").document(trenutniUser.uid).getDocument { (document, error) in
            if let document = document, document.exists {
                if let podatci = document.data(), let ime = podatci["ime"] as? String {
                    DispatchQueue.mainAsync {
                        self.imeKorisnika = ime
                    }
                }
            }
        }
    }
}

extension DispatchQueue {
    static func mainAsync(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}
