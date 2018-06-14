import Foundation
import ObjectMapper

class Event: Mappable {
    
    var name: String?
    var startDate: Date?
    var endDate: Date?
    var location: Location?
    var instructor: String?
    
    required init?(map: Map) {}
    
    public func mapping(map: Map) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let locationTransform = TransformOf<Location, Int>(fromJSON: { (value: Int?) -> Location? in
            guard let locationId = value else {
                return nil
            }
            return Location.init(withId: locationId)
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
