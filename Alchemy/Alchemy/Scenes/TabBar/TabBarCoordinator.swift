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
        
        let scheduleCoordinator2 = ScheduleCoordinator(root: UINavigationController())
        scheduleCoordinator2.start()
        
        viewController.setViewControllers([scheduleCoordinator.root], animated: false)
    }

}
