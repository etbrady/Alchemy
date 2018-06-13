import Foundation
import UIKit
import SnapKit

class ExerciseTableViewCell: UITableViewCell, Reusable {
    
    let exerciseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .alchemyBlue
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
        self.addSubview(exerciseLabel)
        exerciseLabel.snp.makeConstraints(({ make in
            make.center.equalTo(self)
            make.size.equalTo(self).inset(16)
        }))
        
        self.contentView.layoutIfNeeded()
    }
}

extension ExerciseTableViewCell: Configurable {
    typealias Model = String
    
    func configure(with model: Model) {
        exerciseLabel.text = model
    }
}
