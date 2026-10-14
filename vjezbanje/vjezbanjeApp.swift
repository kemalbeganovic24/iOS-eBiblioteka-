import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct vjezbanjeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @State private var nfcKorisnikPrijavljen = false
    @State private var nfcUcitavanje = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Ako je korisnik prijavljen preko NFC-a, prikazujemo HomePage
                if nfcKorisnikPrijavljen {
                    HomePage()
                } else {
                    // Inače prikazujemo uvodni ekran
                    ContentView()
                }

                // Indikator učitavanja pri očitavanju NFC kartice
                if nfcUcitavanje {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 15) {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                        Text("Učitavanje NFC kartice...")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(25)
                    .background(Color.orange)
                    .cornerRadius(15)
                }
            }
            .onOpenURL { url in
                obradiNFCURL(url)
            }
        }
    }

    private func obradiNFCURL(_ url: URL) {
        guard url.scheme == "ebiblioteka" || url.absoluteString.contains("ebiblioteka") else { return }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else { return }
        
        if let uid = queryItems.first(where: { $0.name == "uid" })?.value {
            nfcUcitavanje = true
            let db = Firestore.firestore()
            
            db.collection("users").document(uid).getDocument { document, error in
                if let document = document, document.exists,
                   let email = document.data()?["email"] as? String {
                    
                    Auth.auth().signIn(withEmail: email, password: "123456") { authResult, authError in
                        self.nfcUcitavanje = false
                        if authError == nil {
                            // SwiftUI će automatski zamijeniti ContentView sa HomePage!
                            self.nfcKorisnikPrijavljen = true
                        }
                    }
                } else {
                    self.nfcUcitavanje = false
                }
            }
        }
    }
}

