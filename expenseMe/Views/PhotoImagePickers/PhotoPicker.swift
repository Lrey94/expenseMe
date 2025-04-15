import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var selectedImageData: Data?
    @Binding var date: Date?
    
    var onImagePicked: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = 1
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> PhotoPicker.Coordinator {
        return Coordinator(self)
    }
    
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            guard !results.isEmpty else {
                return
            }
            
            let imageResult = results[0]
            
            if let assetId = imageResult.assetIdentifier {
                let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                if let asset = assetResults.firstObject {
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    options.isNetworkAccessAllowed = true
                    
                    PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, info in
                        DispatchQueue.main.async {
                            self.parent.date = asset.creationDate
                            self.parent.selectedImageData = data
                        }
                    }
                }
            }
        }
        
        private let parent: PhotoPicker
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
    }
}
