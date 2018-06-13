import Foundation

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        setupViews()
    }
    
     private func setupViews() {
        tabBar.backgroundColor = .alchemyBlack
        tabBar.barStyle = .black
        tabBar.tintColor = .alchemyBlue
    }

}
