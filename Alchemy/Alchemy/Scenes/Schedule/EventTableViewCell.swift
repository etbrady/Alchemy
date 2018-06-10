import Foundation
import UIKit
import SnapKit

class EventTableViewCell: UITableViewCell, Configurable, Reusable {
    typealias Model = Event
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Event) {
        nameLabel.text = model.name
    }
    
    private func setupViews() {
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(16)
            make.centerY.equalTo(self)
            make.width.equalTo(self).inset(16)
        })
        
        self.contentView.layoutIfNeeded()
    }
    
}
