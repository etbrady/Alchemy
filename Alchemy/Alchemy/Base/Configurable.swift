import Foundation
import UIKit

protocol Configurable {
    associatedtype Model
    
    func configure(with model: Model)
}

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
