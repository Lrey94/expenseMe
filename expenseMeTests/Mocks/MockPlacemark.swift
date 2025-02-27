import Foundation
import CoreLocation

class MockPlacemark: CLPlacemark {
    private var mockName: String?
    private var mockThoroughfare: String?
    private var mockSubThoroughfare: String?
    private var mockLocality: String?
    private var mockCountry: String?
    private var mockLocation: CLLocation?

    init(name: String? = nil,
         thoroughfare: String? = nil,
         subThoroughfare: String? = nil,
         locality: String? = nil,
         country: String? = nil,
         location: CLLocation? = nil) {
        self.mockName = name
        self.mockThoroughfare = thoroughfare
        self.mockSubThoroughfare = subThoroughfare
        self.mockLocality = locality
        self.mockCountry = country
        self.mockLocation = location
        super.init()
    }

    override var name: String? { return mockName }
    override var thoroughfare: String? { return mockThoroughfare }
    override var subThoroughfare: String? { return mockSubThoroughfare }
    override var locality: String? { return mockLocality }
    override var country: String? { return mockCountry }
    override var location: CLLocation? { return mockLocation }
}
