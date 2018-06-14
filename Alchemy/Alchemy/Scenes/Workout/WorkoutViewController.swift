import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Presentr
import RxDataSources

struct WorkoutSection {
    var header: String
    var items: [Item]
    
    init(for workout: Workout) {
        header = workout.className
        items = workout.exercises
    }
}

extension WorkoutSection: SectionModelType {
    typealias Item = String
    
    init(original: WorkoutSection, items: [String]) {
        self = original
        self.items = items
    }
}

class WorkoutViewController: UIViewController {
    
    var viewModel: WorkoutViewModel? = nil
    let disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        
        tableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: ExerciseTableViewCell.reuseIdentifier)
        
        return tableView
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
        title = "Workout"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor.alchemyBlue
        
        navigationItem.rightBarButtonItem = dateBarButtonItem
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalTo(self.view)
        })
        
    }
    
    private func setupBindings() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<WorkoutSection>(
            configureCell: { (dataSource, table, indexPath, item) in
                guard let cell = table.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.reuseIdentifier, for: indexPath) as? ExerciseTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: item)
                return cell
            },
            titleForHeaderInSection: { (dataSource, section) -> String? in
                return dataSource[section].header
            }
        )
        
        viewModel?
            .workouts
            .map { workouts in
                return workouts.map { workout in
                    return WorkoutSection(for: workout)
                }
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel?
            .date
            .map { date -> String in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d"
                
                return dateFormatter.string(from: date)
            }
            .bind(to: dateBarButtonItem.rx.title)
            .disposed(by: disposeBag)
    }
}

extension WorkoutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
        header.textLabel?.font = .systemFont(ofSize: 22)
        header.textLabel?.sizeToFit()

        header.contentView.backgroundColor = .alchemyLightGrey
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}
