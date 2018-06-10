import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ScheduleViewController: UIViewController {
    
    var viewModel: ScheduleViewModel? = nil
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //setupViews()
        //setupBindings()
    }
    
}
