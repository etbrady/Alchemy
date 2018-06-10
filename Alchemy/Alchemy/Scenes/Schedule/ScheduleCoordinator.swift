import Foundation
import UIKit

class ScheduleCoordinator: NSObject, NavigationCoordinating {
    
    let root: UINavigationController
    var viewController: ScheduleViewController?
    
    init(root: UINavigationController) {
        self.root = root
    }
    
    func createViewController() -> ScheduleViewController {
        let viewController = ScheduleViewController()
        let viewModel = createViewModel(for: viewController)
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func createViewModel(for viewController: ScheduleViewController) -> ScheduleViewModel {
        let viewModel = ScheduleViewModel()
        return viewModel
    }
}
