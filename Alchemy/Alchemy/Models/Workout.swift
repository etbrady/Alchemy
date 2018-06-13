import Foundation

struct Workout {
    let className: String
    let exercises: [String]
    
    init(className: String, exercises: [String]) {
        self.className = className
        self.exercises = exercises
    }
}
