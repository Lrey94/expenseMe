import Foundation
import SwiftData
import MapKit
import Photos

class AddExpenseViewModel: ObservableObject {

    enum AddExpenseErrorBorder {
        case none
        case expenseName
        case expenseAmount
    }

    @Published var selectedImageData: Data?
    @Published var selectedImage: UIImage?
    @Published var isConfirmationDialogPresented = false
    @Published var isImagePickerPresented = false
    @Published var sourceType: SourceType = .camera

    @Published var expenseName: String = ""
    @Published var expenseAmount: Double = 0.0
    @Published var date: Date?

    @Published var showErrorMessage = false
    @Published var addExpenseErrorBorder: AddExpenseErrorBorder = .none
    @Published var errorMessageReason = ""
    @Published var errorMessageRecoverySuggestion = ""
    @Published var geocodingInProgress = false

    let swiftDataManager: SwiftDataManager
    let locationManager: LocationManager

    init(swiftDataManager: SwiftDataManager, locationManager: LocationManager) {
        self.swiftDataManager = swiftDataManager
        self.locationManager = locationManager
    }
    
    func addExpenseItem(completion: @escaping (Bool) -> Void) {
        guard let imageData = selectedImageData else {
            handleError(ExpenseValidationError.imageError)
            completion(false)
            return
        }

        do {
            try validateExpenseItem()
        } catch {
            handleError(error)
            completion(false)
            return
        }

        if let locationCoordinate = extractLocationMetadata(from: imageData) {
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            locationManager.reverseGeoCodeLocation(location: location) { placemark, error in
                if error != nil {
                    self.handleError(ExpenseValidationError.locationError)
                    return
                }

                let expense = self.buildExpenseObject(
                    imageData: imageData,
                    placeMark: placemark,
                    longitude: location.coordinate.longitude,
                    latitude: location.coordinate.latitude
                )
                self.swiftDataManager.insertExpense(expense: expense) { result in
                    if result {
                        completion(true)
                    } else {
                        self.handleError(ExpenseValidationError.insertionError)
                        completion(false)
                    }
                }
            }
        } else {
            let expense = buildExpenseObject(
                imageData: imageData,
                placeMark: nil,
                longitude: nil,
                latitude: nil
            )
            self.swiftDataManager.insertExpense(expense: expense) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
        completion(true)
    }

    private func buildExpenseObject(imageData: Data, placeMark: CLPlacemark?, longitude: Double?, latitude: Double?) -> Expense {
        if let placeMark = placeMark {
            return Expense(expenseName: expenseName,
                           expenseAmount: expenseAmount,
                           image: imageData,
                           expenseImageDate: date,
                           geolocationMetadata: GeoLocation(
                            with: placeMark,
                            longitude: longitude ?? 0.0,
                            latitude: latitude ?? 0.0
                        )
            )
        } else {
            return Expense(expenseName: expenseName,
                           expenseAmount: expenseAmount,
                           image: imageData,
                           expenseImageDate: date
            )
        }
    }

    private func extractLocationMetadata(from imageData: Data) -> CLLocationCoordinate2D? {
        var tempLocation: CLLocationCoordinate2D? = nil

        var extractedMetadata: [String: Any] = [:]

        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        guard let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else { return nil }

        print(metadata)
        
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
        }

        return tempLocation
    }

    func deleteExpenseItem(expense: Expense) {
        swiftDataManager.deleteExpense(expense: expense)
    }

    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            showErrorMessage = true
            errorMessageReason = "Photo library access is denied or restricted."
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        completion(true)
                    case .denied, .restricted:
                        self.showErrorMessage = true
                        self.errorMessageReason = "Photo library access is denied or restricted."
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
    
    private func handleError(_ error: Error) {
        if let localisedError = error as? LocalizedError {
            errorMessageReason = localisedError.failureReason ?? "An Unknown error occured."
            errorMessageRecoverySuggestion = localisedError.recoverySuggestion ?? ""
        } else {
            errorMessageReason = "An Unknown error occured."
        }
        showErrorMessage = true
    }

    private func validateExpenseItem() throws {
        guard !expenseName.isEmpty else {
            addExpenseErrorBorder = .expenseName
            throw ExpenseValidationError.nameEmptyError
        }

        guard expenseName.count <= 30 else {
            addExpenseErrorBorder = .expenseName
            throw ExpenseValidationError.nameLengthTooLongError
        }

        guard expenseAmount != 0.0 else {
            addExpenseErrorBorder = .expenseAmount
            throw ExpenseValidationError.amountIsZeroError
        }

        guard expenseAmount <= 999.999 else {
            addExpenseErrorBorder = .expenseAmount
            throw ExpenseValidationError.amountIsTooHighError
        }
    }

    func resetExpenseData() {
        selectedImageData = nil
        expenseName = ""
        expenseAmount = 0.0
        addExpenseErrorBorder = .none
    }
}
