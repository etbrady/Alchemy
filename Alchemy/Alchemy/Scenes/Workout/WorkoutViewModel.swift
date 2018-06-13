import Foundation
import RxSwift

struct WorkoutViewModel {
    let workouts: Observable<[Workout]>
    let date: Observable<Date>
    
    let workoutNetworker = WorkoutNetworker()
    
    init(date: Observable<Date>) {
        let testWorkouts = [
            Workout(className: "A10", exercises: ["Push Ups", "Sit Ups"]),
            Workout(className: "AStrong", exercises: ["Bench Press", "Squats"])
        ]
       // workouts = Observable<[Workout]>.just(testWorkouts)
        
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
        
        self.date = date
    }
}
