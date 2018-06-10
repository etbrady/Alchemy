import Foundation
import UIKit
import SnapKit

class EventTableViewCell: UITableViewCell, Reusable {
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let topRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let bottomRowStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .alchemyBlue
        label.font = .systemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .alchemyDarkGrey
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }()
    
    let instructorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .alchemyDarkGrey
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .alchemyLightGrey
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5

        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        topRowStackView.addArrangedSubview(nameLabel)
        topRowStackView.addArrangedSubview(instructorLabel)
        
        bottomRowStackView.addArrangedSubview(timeLabel)
        bottomRowStackView.addArrangedSubview(locationLabel)
        
        verticalStackView.addArrangedSubview(topRowStackView)
        verticalStackView.addArrangedSubview(bottomRowStackView)
        
        self.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints(({ make in
            make.center.equalTo(self)
            make.size.equalTo(self).inset(16)
        }))
        
        self.contentView.layoutIfNeeded()
    }
}

extension EventTableViewCell: Configurable {
    typealias Model = Event
    
    func configure(with model: Event) {
        nameLabel.text = model.name
        timeLabel.text = getTime(from: model)
        instructorLabel.text = model.instructor
        locationLabel.text = model.location?.rawValue
    }
    
    private func getTime(from event: Event) -> String {
        guard let startDate = event.startDate
            , let endDate = event.endDate else {
                return ""
        }
        let startDateString = format(startDate)
        let endDateString = format(endDate)
        
        return "\(startDateString) - \(endDateString)"
    }
    
    private func format(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: date)
    }
}
