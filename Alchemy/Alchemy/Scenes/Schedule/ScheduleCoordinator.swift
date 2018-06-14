import Foundation
import UIKit
import RxSwift

class ScheduleCoordinator: NSObject, NavigationCoordinating {
    
    let root: UINavigationController
    var viewController: ScheduleViewController?
    
    let datePickerCoordinator: DatePickerCoordinator
    let dateSubject = BehaviorSubject<Date>(value: Date())
    
    let locationPickerCoordinator: LocationPickerCoordinator
    let locationSubject = BehaviorSubject<Location?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    init(root: UINavigationController) {
        self.root = root
        datePickerCoordinator = DatePickerCoordinator(root: root, dateSubject: dateSubject)
        locationPickerCoordinator = LocationPickerCoordinator(root: root, locationSubject: locationSubject)
    }
    
    func createViewController() -> ScheduleViewController {
        return ScheduleViewController()
    }
    
    func configure(_ viewController: ScheduleViewController) {
        viewController.viewModel = ScheduleViewModel(date: dateSubject.asObservable(), location: locationSubject.asObservable())
        
        viewController.locationBarButtonItem.rx.tap.subscribe({ _ in
            self.locationPickerCoordinator.start()
        }).disposed(by: disposeBag)
        
        viewController.dateBarButtonItem.rx.tap.subscribe({ _ in
            self.datePickerCoordinator.start()
        }).disposed(by: disposeBag)
    }
    
}
