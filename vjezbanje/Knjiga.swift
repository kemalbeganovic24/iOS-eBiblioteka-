import Foundation

struct Knjiga: Identifiable, Codable {
    var id: String
        var naslov: String
        var autor: String
        var urednici: String?
        var isbn: String?
        var isbnk: String?
        var isbnun: String?
        var tip: String?
        var kolekcija: String?
        var broj: Int
        var izdanje: String?
        var izdavac: String?
        var jezik: String
        var issn: String?
        var cobissbihId: String?
        var ciphr: String?
        var vrsta: String
        var tkoJeUnio: String
        var datumUnosa: Date
        var naStanju: Bool
        var coverUrl: String?
}

    enum CodingKeys: String, CodingKey {
        case id
        case naslov
        case autor
        case broj
        case jezik
        case tkoJeUnio
        case datumUnosa
        case naStanju
        case vrsta = "žanr"
        case coverUrl = "cover"
    }

