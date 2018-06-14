import Foundation

enum Location: String {
    case edina = "Edina"
    case highlandPark = "Highland Park"
    case loHi = "LoHi"
    case northeast = "Northeast"
    case northLoop = "North Loop"
    
    static let all = [edina, highlandPark, loHi, northLoop, northeast]
    
    init?(withId id: Int) {
        switch id {
        case 10514:
            self = .northLoop
        case 18997:
            self = .northeast
        case 27577:
            self = .edina
        case 28880:
            self = .highlandPark
        case 30510:
            self = .loHi
        default:
            return nil
        }
    }
}
