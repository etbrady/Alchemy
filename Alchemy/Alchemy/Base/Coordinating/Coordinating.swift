import Foundation
import UIKit

protocol Coordinating: class {
    associatedtype RootViewController: UIViewController
    associatedtype ViewController: UIViewController
    
    var root: RootViewController { get }
    var viewController: ViewController? { get set }
    
    func createViewController() -> ViewController
    func configure(_ viewController: ViewController)
    func show(_ viewController: ViewController)
    func dismiss()
}

extension Coordinating {
    func start() {
        let vc = createViewController()
        viewController = vc
        configure(vc)
        show(vc)
    }
    
    func stop() {
        dismiss()
        viewController = nil
    }
}

extension Coordinating {
    func configure(_ viewController: ViewController) {
    }
    func show(_ viewController: ViewController) {
        root.present(viewController, animated: true , completion: nil)
    }
    func dismiss() {
        root.dismiss(animated: true, completion: nil)
    }
}
