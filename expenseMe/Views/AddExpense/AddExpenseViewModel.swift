//
//  AddExpenseViewModel.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 08/04/2024.
//

import Foundation
import SwiftData
import MapKit
import Photos

class AddExpenseViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isConfirmationDialogPresented = false
    @Published var isImagePickerPresented = false
    @Published var sourceType: SourceType = .camera
    @Published var expenseName: String = ""
    @Published var expenseAmount: Double = 0.0
    
    @Published var showErrorMessage = false
    @Published var errorMessage = ""
    
    @Published var date: Date?
    @Published var metadataLocationDetails: GeoLocation?
    @Published var showMetadataDetails = false
    @Published var geocodingInProgress = false
    @Published var metadataErrorMessage = ""
    
    private let modelContext: ModelContext
    private let locationManager: LocationManager
    
    init(modelContext: ModelContext, locationManager: LocationManager) {
        self.modelContext = modelContext
        self.locationManager = locationManager
    }
    
    func addExpenseItem() {
        if image != nil {
            if validateExpenseItem() {
                let imageData = image?.jpegData(compressionQuality: 1)
                if let date = date, let data = imageData {
                    let location = extractLocationMetadata(from: data)
                    if let locationData = location {
                        print(locationData)
                        let expenseItem = Expense(expenseName: expenseName, expenseAmount: expenseAmount, image: imageData, expenseImageDate: date, expenseImageLatitude: locationData.latitude, expenseImageLongitude: locationData.longitude)
                        modelContext.insert(expenseItem)
                    }
                } else {
                    let expenseItem = Expense(expenseName: expenseName, expenseAmount: expenseAmount, image: imageData)
                    modelContext.insert(expenseItem)
                }
            } else {
                self.showErrorMessage = true
                self.errorMessage = "Check the details you have entered"
            }
        } else {
            self.showErrorMessage = true
            self.errorMessage = "Please select or take an image"
        }
    }
    
    private func extractLocationMetadata(from imageData: Data) -> CLLocationCoordinate2D? {
        var tempLocation: CLLocationCoordinate2D? = nil
        
        var extractedMetadata: [String: Any] = [:]
        
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else { return nil }
                
        if let gpsData = metadata[kCGImagePropertyGPSDictionary as String] as? [String: Any] {
            let latitude = gpsData[kCGImagePropertyGPSLatitude as String] as? Double
            let latitudeRef = gpsData[kCGImagePropertyGPSLatitudeRef as String] as? String
            let longitude = gpsData[kCGImagePropertyGPSLongitude as String] as? Double
            let longitudeRef = gpsData[kCGImagePropertyGPSLongitudeRef as String] as? String
            
            if let latitude = latitude, let longitude = longitude {
                let lat = latitudeRef == "S" ? -latitude : latitude
                let lon = longitudeRef == "W" ? -longitude : longitude
                tempLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            }
        }
        
        if let tiffData = metadata[kCGImagePropertyTIFFDictionary as String] as? [String: Any] {
            extractedMetadata["Camera Info"] = tiffData
            print("Metadata: \(extractedMetadata)")
        }
        
        return tempLocation
    }
    
    func deleteExpenseItem(expense: Expense) {
        modelContext.delete(expense)
    }
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            showErrorMessage = true
            errorMessage = "Photo library access is denied or restricted."
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(true)
                    case .denied, .restricted:
                        self.showErrorMessage = true
                        self.errorMessage = "Photo library access is denied or restricted."
                        completion(false)
                    case .notDetermined:
                        completion(false)
                    case .limited:
                        completion(true)
                    @unknown default:
                        fatalError("Unknown photo library authorization status.")
                    }
                }
            }
        case .limited:
            completion(true)
        @unknown default:
            fatalError("Unknown photo library authorization status.")
        }
    }
    
    func presentPhotoPicker() {
        requestPhotoLibraryAccess { granted in
            if granted {
                self.isImagePickerPresented = true
            }
        }
    }
    
//    func geocodePhotoMetadata(completionHandler: @escaping (Result<Bool, GeocodeError>) -> Void) {
//        self.geocodingInProgress = true
//        guard let location = self.location else {
//            print("bad location")
//            completionHandler(.failure(.badGeocode))
//            self.geocodingInProgress = false
//            return
//        }
//        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { placemarks, error in
//            DispatchQueue.main.async {
//                guard let placemark = placemarks?.first else {
//                    completionHandler(.failure(.nilPlacemark))
//                    return
//                }
//                let reversedGeoLocation = GeoLocation(with: placemark)
//                self.metadataLocationDetails = reversedGeoLocation
//                completionHandler(.success(true))
//                self.geocodingInProgress = false
//            }
//        }
//    }
    
    private func validateExpenseItem() -> Bool {
        if expenseName.isEmpty, expenseAmount == 0.0 {
            return false
        }
        return true
    }
    
    private func resetExpenseData() {
        image = nil
        expenseName = ""
        expenseAmount = 0.0
    }
}
