import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Presentr

class LocationPickerViewController: UIViewController {
    
    var viewModel: LocationPickerViewModel? = nil
    let disposeBag = DisposeBag()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select A Location"
        label.textColor = .alchemyBlue
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        
        return label
    }()
    
    let locationPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.tintColor = .alchemyBlue
        picker.clipsToBounds = true
        
        return picker
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .alchemyBlue
        button.layer.cornerRadius = 10
        button.showsTouchWhenHighlighted = true
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .alchemyBlue
        button.layer.cornerRadius = 10
        button.showsTouchWhenHighlighted = true
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(locationPicker)
        
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(doneButton)
        
        stackView.addArrangedSubview(buttonStackView)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints({ make in
            make.size.equalTo(self.view).inset(16)
            make.center.equalTo(self.view)
        })
    }
    
    private func setupBindings() {
        viewModel?.availableLocations
            .bind(to: locationPicker.rx.itemTitles) { _, item in
                return item?.rawValue ?? "All Locations"
            }
            .disposed(by: disposeBag)
        
        locationPicker.rx.modelSelected(Location?.self).subscribe( { selectedModel in
            let selectedLocation = selectedModel.element?.first ?? nil
            self.viewModel?.selectedLocation.value = selectedLocation
        }).disposed(by: disposeBag)
    }
    
}
