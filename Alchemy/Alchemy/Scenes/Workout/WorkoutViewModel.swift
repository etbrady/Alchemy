import Foundation
import RxSwift

struct WorkoutViewModel {
    let workouts: Observable<[Workout]>
    let date: Observable<Date>
    
    init(date: Observable<Date>) {
        let testWorkouts = [
            Workout(className: "A10", exercises: ["Push Ups", "Sit Ups"]),
            Workout(className: "AStrong", exercises: ["Bench Press", "Squats"])
        ]
        workouts = Observable<[Workout]>.just(testWorkouts)
        
        self.date = date
    }
}
