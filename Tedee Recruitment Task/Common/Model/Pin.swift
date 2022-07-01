import Foundation

struct Pin: Codable {
    let name: String
    let code: String
}

extension Pin: Equatable {
    static func ==(lhs: Pin, rhs: Pin) -> Bool {
        return lhs.name == rhs.name && lhs.code == rhs.code
    }
}
