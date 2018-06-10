import Foundation
import ObjectMapper

enum Location: String {
    case alchemyNorthLoop = "Alchemy North Loop"
    case alchemyNortheast = "Alchemy Northeast"
    case alchemyEdina = "Alchemy Edina"
    
    static let all = [alchemyNorthLoop, alchemyNortheast, alchemyEdina]
}

class Event: Mappable {
    
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: Location?
    var instructor: String?
    
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let locationTransform = TransformOf<Location, Int>(fromJSON: { (value: Int?) -> Location? in
            guard let locationId = value else {
                return nil
            }
            switch locationId {
            case 10514:
                return Location.alchemyNorthLoop
            case 18997:
                return Location.alchemyNortheast
            case 27577:
                return Location.alchemyEdina
            default:
                return nil
            }
        }, toJSON: { _ in
            return nil
        })
        
        name <- map["name"]
        startDate <- (map["start_at"], DateFormatterTransform(dateFormatter: dateFormatter))
        endDate <- (map["end_at"], DateFormatterTransform(dateFormatter: dateFormatter))
        location <- (map["location_id"], locationTransform)
        instructor <- map["staff_members.0.name"]
    }
    
    private static func getDateFrom(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: string)
    }
    
}
