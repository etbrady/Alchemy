import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Presentr

class ScheduleViewController: UIViewController {
    
    var viewModel: ScheduleViewModel? = nil
    let disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.reuseIdentifier)
        
        return tableView
    }()
    
    let locationBarButtonItem: UIBarButtonItem = {
        let dateBarButtonItem = UIBarButtonItem(title: "All Locations", style: .plain, target: nil, action: nil)
        dateBarButtonItem.tintColor = .white
        return dateBarButtonItem
    }()
    
    let dateBarButtonItem: UIBarButtonItem = {
        let dateBarButtonItem = UIBarButtonItem(title: "Date", style: .plain, target: nil, action: nil)
        dateBarButtonItem.tintColor = .white
        return dateBarButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        title = "Schedule"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor.alchemyBlue

        navigationItem.leftBarButtonItem = locationBarButtonItem
        navigationItem.rightBarButtonItem = dateBarButtonItem
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalTo(self.view)
        })
        
    }
    
    private func setupBindings() {
        viewModel?
            .filteredEvents
            .bind(to: tableView.rx.items(cellIdentifier: EventTableViewCell.reuseIdentifier, cellType: EventTableViewCell.self)) { index, scent, cell in
                cell.configure(with: scent)
            }.disposed(by: disposeBag)
        
        viewModel?
            .date
            .map { date -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                
                return dateFormatter.string(from: date)
            }
            .bind(to: dateBarButtonItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel?
            .location
            .map { location -> String in
                return location?.rawValue ?? "All Locations"
            }
            .bind(to: locationBarButtonItem.rx.title)
            .disposed(by: disposeBag)
    }
    
}
