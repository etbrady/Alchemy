import Foundation
import UIKit

protocol NavigationCoordinating: Coordinating where RootViewController == UINavigationController {}

extension NavigationCoordinating {
    func show(_ viewController: Self.ViewController) {
        root.pushViewController(viewController, animated: true)
    }
    
    func dismiss() {
        root.dismiss(animated: true, completion: nil)
    }
}
