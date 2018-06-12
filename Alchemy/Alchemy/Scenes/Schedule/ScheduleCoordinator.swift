import Foundation
import UIKit
import RxSwift

class ScheduleCoordinator: NSObject, NavigationCoordinating {
    
    let root: UINavigationController
    var viewController: ScheduleViewController?
    
    let datePickerCoordinator: DatePickerCoordinator
    let dateSubject = BehaviorSubject<Date>(value: Date())
    
    let disposeBag = DisposeBag()
    
    init(root: UINavigationController) {
        self.root = root
        datePickerCoordinator = DatePickerCoordinator(root: root, dateSubject: dateSubject)
    }
    
    func createViewController() -> ScheduleViewController {
        let viewController = ScheduleViewController()
        let viewModel = ScheduleViewModel(date: dateSubject.asObservable())
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    func configure(_ viewController: ScheduleViewController) {
        viewController.dateBarButtonItem.rx.tap.subscribe({ _ in
            self.datePickerCoordinator.start()
        }).disposed(by: disposeBag)
    }
    
}
