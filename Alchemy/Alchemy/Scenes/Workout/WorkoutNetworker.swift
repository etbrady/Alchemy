import Foundation
import RxCocoa
import RxSwift
import RxAlamofire
import Alamofire
import ObjectMapper
import SwiftSoup

struct WorkoutNetworker {
    
    let baseUrl = "https://alchemy365.com/"
    
    func fetchWorkouts(for date: Observable<Date>) -> Driver<Result<[Workout]>> {
        return date
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .flatMapLatest { date -> Observable<(HTTPURLResponse, String)> in
                let url = self.getUrl(from: date)
                return requestString(.get, url)
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, htmlString) -> Result<[Workout]> in
                if response.statusCode == 200 {
                    let workouts = self.parseWorkouts(from: htmlString)
                    
                    return .success(workouts)
                    
                } else {
                    return .failure(NetworkingError.networkError)
                }
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: Result<[Workout]>.failure(NetworkingError.parsingError))
    }
    
    private func parseWorkouts(from htmlString: String) -> [Workout] {
        guard let document: Document = try? SwiftSoup.parse(htmlString)
            , let singleContentElements = try? document.getElementsByClass("mk-single-content clearfix")
            , let workoutContent = singleContentElements.first() else {
            return []
        }
        
        let workoutText = getTextRecursively(from: workoutContent)
            .map { text in
                return text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            .filter { text in
                return !text.isEmpty
            }
        
        var workouts = [
            Workout(className: "A10", exercises: []),
            Workout(className: "A20", exercises: []),
            Workout(className: "AStrong", exercises: []),
            Workout(className: "APulse", exercises: [])
        ]

        var currentWorkoutIndex: Int? = nil
        for text in workoutText {
            if let workoutIndex = workouts.index(where: { (workout) -> Bool in
                return workout.className == text
            }) {
                currentWorkoutIndex = workoutIndex
                continue
            }
            guard let currentWorkoutIndex = currentWorkoutIndex else {
                continue
            }
            workouts[currentWorkoutIndex].exercises.append(text)
        }
        
        return workouts
    }
    
    private func getTextRecursively(from element: Element) -> [String] {
        let childrenText = element.children().reduce([]) { text, element in
            return text + getTextRecursively(from: element)
        }
        
        return getText(from: element.textNodes()) + childrenText
    }
    
    private func getText(from textNodes: [TextNode]) -> [String] {
        return textNodes.map { textNode in
            return textNode.text()
        }
    }
 
    private func getUrl(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/EEEE-MMddYY/"
        
        let formattedDate = dateFormatter.string(from: date)
        return baseUrl + formattedDate
    }
}
