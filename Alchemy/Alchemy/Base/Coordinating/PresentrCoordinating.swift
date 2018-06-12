import Foundation
import UIKit
import Presentr

protocol PresentrCoordinating: Coordinating {
    var presentr: Presentr { get }
}

extension PresentrCoordinating where RootViewController: UIViewController {
    func show(_ viewController: Self.ViewController) {
        root.customPresentViewController(presentr, viewController: viewController, animated: true)
    }
}
