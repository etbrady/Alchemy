import Foundation
import RxSwift

struct LocationPickerViewModel {
    
    let availableLocations: Observable<[Location?]>
    let selectedLocation: Variable<Location?>
    
    init() {
        availableLocations =  Observable<[Location?]>.just([nil] + Location.all)
        selectedLocation = Variable<Location?>(nil)
    }
}
