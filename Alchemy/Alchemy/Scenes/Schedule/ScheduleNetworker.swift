import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper

struct ScheduleNetworker {
    
    let baseUrl = "https://alchemy365.frontdeskhq.com/api/v2/"
    let clientId = "WWgvG1fId8iDU3rgoFXvz4A2kLnxDBSsOFacfk8X"
    
    func fetchSchedule(for date: Observable<Date>) -> Driver<Result<[Event]>> {
        return date
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .flatMapLatest { date -> Observable<(HTTPURLResponse, Any)> in
                let url = self.baseUrl + "front/event_occurrences.json"
                let parameters = self.getEventsRequestParameters(from: date)
                return requestJSON(.get, url, parameters: parameters)
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, json) -> Result<[Event]> in
                if response.statusCode == 200 {
                    guard let json = json as? [String : [[String: Any]]]
                        , let eventsJson = json["event_occurrences"] else {
                            return .failure(NetworkingError.parsingError)
                    }
                    
                    let events = Mapper<Event>().mapArray(JSONArray: eventsJson)
                    return .success(events)

                } else {
                    return .failure(NetworkingError.networkError)
                }
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: Result<[Event]>.failure(NetworkingError.parsingError))
    }
    
    func getEventsRequestParameters(from date: Date) -> Parameters {
        let dates = getStartAndEndDateStringsFrom(date)
        let parameters = [
            "client_id": clientId,
            "from": dates.0,
            "to": dates.1
        ]
        
        return parameters
    }
    
    func getStartAndEndDateStringsFrom(_ date: Date) -> (String,String) {
        let startDate = Calendar.current.startOfDay(for: date)
        
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endDate = Calendar.current.date(byAdding: components, to: startDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate!)
        
        return (startDateString,endDateString)
    }
}
