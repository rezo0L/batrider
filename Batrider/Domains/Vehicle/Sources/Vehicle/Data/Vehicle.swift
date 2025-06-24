import Foundation

struct Vehicle: Decodable {
    let name: String
    let id: UUID
    let category: String
    let price: Double
    let currency: String
}
