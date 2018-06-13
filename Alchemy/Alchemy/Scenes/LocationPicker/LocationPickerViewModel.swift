import Foundation
import RxSwift

struct LocationPickerViewModel {
    
    let availableLocations = Observable<[Location?]>.just([nil] + Location.all)
    let selectedLocation = Variable<Location?>(nil)
    
    init() {
        //ava
    }
}
