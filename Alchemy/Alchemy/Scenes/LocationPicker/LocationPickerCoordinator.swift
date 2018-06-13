import Foundation
import UIKit
import RxSwift
import RxDataSources
import Presentr

class LocationPickerCoordinator: NSObject, PresentrCoordinating {
    
    let root: UINavigationController
    let locationSubject: BehaviorSubject<Location?>
    
    var viewController: LocationPickerViewController?
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
    
    init(root: UINavigationController, locationSubject: BehaviorSubject<Location?>) {
        self.root = root
        self.locationSubject = locationSubject
    }
    
    func createViewController() -> LocationPickerViewController {
        let viewController = LocationPickerViewController()
        let viewModel = LocationPickerViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    func configure(_ viewController: LocationPickerViewController) {       
        viewController.doneButton.rx.tap.subscribe({ _ in
            let selectedLocation = viewController.viewModel?.selectedLocation.value
            self.locationSubject.onNext(selectedLocation)
            self.stop()
        }).disposed(by: disposeBag)
        
        viewController.cancelButton.rx.tap.subscribe({ _ in
            self.stop()
        }).disposed(by: disposeBag)
    }
    
}
