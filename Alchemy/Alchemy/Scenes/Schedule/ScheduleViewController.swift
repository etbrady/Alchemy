import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ScheduleViewController: UIViewController {
    
    var viewModel: ScheduleViewModel? = nil
    let disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsMultipleSelection = true
        tableView.allowsSelection = true
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalTo(self.view)
        })
    }
    
    private func setupBindings() {
        viewModel?
            .events
            .bind(to: tableView.rx.items(cellIdentifier: EventTableViewCell.reuseIdentifier, cellType: EventTableViewCell.self)) { index, scent, cell in
                cell.configure(with: scent)
            }.disposed(by: disposeBag)
    }
    
}
