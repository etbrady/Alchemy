import Foundation
import RxSwift

struct ScheduleViewModel {
    
    let disposeBag = DisposeBag()
    
    let events: Observable<[Event]>
    let date: Observable<Date>
    
    let scheduleNetworker = ScheduleNetworker()
    
    init(date: Observable<Date>) {
        self.date = date
        
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
            }.asObservable()
    }
    
}
