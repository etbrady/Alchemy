import Foundation
import UIKit

class TabBarCoordinator: NSObject, Coordinating {

    let root: UINavigationController
    var viewController: UITabBarController?
    
    init(root: UINavigationController) {
        self.root = root
    }
    
    func createViewController() -> UITabBarController {
        let tabBarController = TabBarViewController()
            
        return tabBarController
    }
    
    func configure(_ viewController: UITabBarController) {
        let scheduleCoordinator = ScheduleCoordinator(root: UINavigationController())
        scheduleCoordinator.start()
        let scheduleTabBarItem = UITabBarItem(title: "Schedule", image: #imageLiteral(resourceName: "Calendar"), tag: 0)
        scheduleCoordinator.viewController?.tabBarItem = scheduleTabBarItem
        
        let workoutCoordinator = WorkoutCoordinator(root: UINavigationController())
        workoutCoordinator.start()
        let workoutTabBarItem = UITabBarItem(title: "Workout", image: #imageLiteral(resourceName: "Pushups"), tag: 0)
        workoutCoordinator.viewController?.tabBarItem = workoutTabBarItem
        
        viewController.setViewControllers([scheduleCoordinator.root, workoutCoordinator.root], animated: false)
    }

}
