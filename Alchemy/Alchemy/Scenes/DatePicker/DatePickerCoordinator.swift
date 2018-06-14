import Foundation
import UIKit
import RxSwift
import Presentr

class DatePickerCoordinator: NSObject, PresentrCoordinating {

    let root: UINavigationController
    let dateSubject: BehaviorSubject<Date>
    
    var viewController: DatePickerViewController?    
    let disposeBag = DisposeBag()
    
    var presentr: Presentr = {
        let width = ModalSize.default
        let height = ModalSize.half
        let center = ModalCenterPosition.center
        
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let presentr = Presentr(presentationType: customType)
        presentr.transitionType = .coverHorizontalFromRight
        presentr.roundCorners = true
        return presentr
    }()    
    
    init(root: UINavigationController, dateSubject: BehaviorSubject<Date>) {
        self.root = root
        self.dateSubject = dateSubject
    }
    
    func createViewController() -> DatePickerViewController {
        return DatePickerViewController()
    }
    
    func configure(_ viewController: DatePickerViewController) {
        if let date = try? dateSubject.value() {
            viewController.datePicker.date = date
        }

        viewController.doneButton.rx.tap.subscribe({ _ in
            self.dateSubject.onNext(viewController.datePicker.date)
            self.stop()
        }).disposed(by: disposeBag)
        
        viewController.cancelButton.rx.tap.subscribe({ _ in
            self.stop()
        }).disposed(by: disposeBag)
    }
    
}
