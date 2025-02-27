import Foundation
import CoreLocation
import XCTest

class LocationManagerTests: XCTestCase {
    
    var mockLocationManager: MockLocationManager!
    var location: CLLocation!
    var locationCoordinates: CLLocationCoordinate2D!
    
    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
        location = CLLocation(latitude: 37.7749, longitude: -122.4194)
        locationCoordinates = CLLocationCoordinate2D(
            latitude: 37.7749,
            longitude: -122.4194
        )
    }
    
    override func tearDown() {
        mockLocationManager = nil
        location = nil
        super.tearDown()
    }
    
    func testReverseGeoCodeLocationSuccess() {
        //Arrange
        let mockPlacemark = CLPlacemark.mock(
            coordinate: locationCoordinates,
            name: "mock-name"
        )
        mockLocationManager.mockPlacemark = mockPlacemark
        mockLocationManager.shouldReturnError = false
        //Act
        mockLocationManager.reverseGeoCodeLocation(location: location) { placemark, error in
            //Assert
            XCTAssertNil(error)
            XCTAssertEqual(placemark, mockPlacemark)
        }
    }
    
    func testReverseGeoCodeLocationFailure() {
        //Arrange
        mockLocationManager.shouldReturnError = true
        //Act
        mockLocationManager.reverseGeoCodeLocation(location: location) { placemark, error in
            //Assert
            XCTAssertNotNil(error)
            XCTAssertNil(placemark)
            XCTAssertEqual(error?.localizedDescription, "Mock Error")
        }
    }
}
