import Foundation
import UIKit
import RxSwift

class WorkoutCoordinator: NSObject, NavigationCoordinating {
    
    let root: UINavigationController
    var viewController: WorkoutViewController?
    
    let datePickerCoordinator: DatePickerCoordinator
    let dateSubject = BehaviorSubject<Date>(value: Date())
    
    let disposeBag = DisposeBag()
    
    init(root: UINavigationController) {
        self.root = root
        datePickerCoordinator = DatePickerCoordinator(root: root, dateSubject: dateSubject)
    }
    
    func createViewController() -> WorkoutViewController {
        let viewController = WorkoutViewController()
        let viewModel = WorkoutViewModel(date: dateSubject.asObservable())
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    func configure(_ viewController: WorkoutViewController) {
        viewController.dateBarButtonItem.rx.tap.subscribe({ _ in
            self.datePickerCoordinator.start()
        }).disposed(by: disposeBag)
    }
    
}
