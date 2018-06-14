import Foundation
import RxSwift

struct WorkoutViewModel {
    let workouts: Observable<[Workout]>
    let date: Observable<Date>
    
    let workoutNetworker = WorkoutNetworker()
    
    init(date: Observable<Date>) {
        self.date = date

        workouts = workoutNetworker
            .fetchWorkouts(for: date)
            .map { result -> [Workout] in
                switch result {
                case .success(let workouts):
                    return workouts
                case .failure(let error):
                    print(error.localizedDescription)
                    return []
                }
            }
            .asObservable()
    }
}
