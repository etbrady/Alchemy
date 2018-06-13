import Foundation
import RxSwift

struct ScheduleViewModel {
    
    let disposeBag = DisposeBag()
    
    let events: Observable<[Event]>
    let location: Observable<Location?>
    let date: Observable<Date>
    
    let filteredEvents: Observable<[Event]>
    
    let scheduleNetworker = ScheduleNetworker()
    
    init(date: Observable<Date>, location: Observable<Location?>) {
        self.date = date
        self.location = location
        
        events = scheduleNetworker
            .fetchSchedule(for: date)
            .map { result -> [Event] in
                switch result {
                case .success(let events):
                    return events.sorted(by: { (event1: Event, event2: Event) -> Bool in
                        guard let event1StartDate = event1.startDate
                            , let event2StartDate = event2.startDate else {
                                return true
                        }
                        return event1StartDate < event2StartDate
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                    return []
                }
            }
            .asObservable()
        
        filteredEvents = Observable.combineLatest(events, location) { events, location in
            return events.filter { event in
                guard let location = location else {
                    return true
                }
                return event.location == location
            }
        }
    }
    
}
