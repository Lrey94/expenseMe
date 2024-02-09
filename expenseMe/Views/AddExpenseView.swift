//
//  AddExpenseView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 06/12/2023.
//

import SwiftUI
import PhotosUI

struct AddExpenseView: View {
    
    @State private var image: UIImage?
    @State private var isConfirmationDialogPresented = false
    @State private var isImagePickerPresented = false
    @State private var sourceType: SourceType = .camera
    
    var body: some View {
        ZStack() {
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 100, height: 75)
                .foregroundStyle(.green)
                .shadow(radius: 2)
            .padding(.top, 20)
            .onTapGesture {
                isConfirmationDialogPresented = true
            }
            .confirmationDialog("Choose an option", isPresented: $isConfirmationDialogPresented) {
                Button("Camera") {
                    sourceType = .camera
                    isImagePickerPresented = true
                }
                Button("Photo Library") {
                    sourceType = .photoLibrary
                    isImagePickerPresented = true
                }
            }
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            }
            
            Spacer()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            if sourceType == .camera {
                ImagePicker(isPresented: $isImagePickerPresented, image: $image, sourceType: .camera)
            } else {
                PhotoPicker(selectedImage: $image)
            }
        }
    }
}

#Preview {
    AddExpenseView()
}
