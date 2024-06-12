//
//  EditExpenseView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 15/04/2024.
//

import SwiftUI

struct EditExpenseView: View {
    
    @EnvironmentObject private var addExpenseViewModel: AddExpenseViewModel
    
    static let tag = "EditExpenseView"
    
    @Binding var path: NavigationPath
    
    let expense: Expense
    
    var body: some View {
        VStack {
            if let imageData = expense.image, let uiImage = UIImage(data: imageData) {
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading) {
                        Text("Your Chosen Image")
                            .fontWeight(.bold)
                            .font(.title3)
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    Button(action: {
                        withAnimation {
                            expense.image = nil
                        }
                    }) {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 37)
                            .foregroundColor(.red)
                            .symbolRenderingMode(.multicolor)
                    }
                    .padding(10)
                    .offset(x: 20, y: 10)
                }
                .padding(.top)
            } else {
                cameraButton
                    .padding()
                    .sheet(isPresented: $addExpenseViewModel.isImagePickerPresented) {
                        if addExpenseViewModel.sourceType == .camera {
                            ImagePicker(isPresented: $addExpenseViewModel.isImagePickerPresented, image: $addExpenseViewModel.image, sourceType: .camera)
                        } else {
                            PhotoPicker(selectedImage: $addExpenseViewModel.image) {
                                handleImagePicked()
                            }
                        }
                    }
            }
            
            AddExpenseNameTextField(expenseName: $addExpenseViewModel.expenseName, text: "Enter expense name")
            AddExpenseAmountTextField(expenseAmount: $addExpenseViewModel.expenseAmount, text: "Enter expense amount")
            
            saveButton
            
            Spacer()
            
            deleteButton
        }
        .alert(isPresented: $addExpenseViewModel.showErrorMessage) {
            Alert(title: Text("Error!"), message: Text(addExpenseViewModel.errorMessage),
                  dismissButton: .default(Text("Got it!")))
        }
    }
    
    var saveButton: some View {
        Button {
            if addExpenseViewModel.addExpenseItem() {
                path = NavigationPath()
            }
        } label: {
            HStack {
                Image(systemName: "checkmark")
                Text("Save")
            }
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .frame(width: (UIScreen.current?.bounds.width ?? 0) - 60, height: 45)
            .background(RoundedRectangle(cornerRadius: 10).fill(.green))
        }
        .padding()
    }
    
    var deleteButton: some View {
        Button {
            addExpenseViewModel.deleteExpenseItem(expense: expense)
        } label: {
            HStack {
                Image(systemName: "trash.fill")
                Text("Delete")
            }
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            .frame(width: (UIScreen.current?.bounds.width ?? 0) - 60, height: 45)
            .background(RoundedRectangle(cornerRadius: 10).fill(.red.opacity(0.8)))
        }
        .padding()
    }
    
    var cameraButton: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundStyle(.secondary)
                    .frame(width: 110, height: 110)
                    .shadow(radius: 5)
                Image(systemName: "photo.badge.plus.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                    .onTapGesture {
                        addExpenseViewModel.isConfirmationDialogPresented = true
                    }
                    .confirmationDialog("Choose an option", isPresented: $addExpenseViewModel.isConfirmationDialogPresented) {
                        Button("Camera") {
                            addExpenseViewModel.sourceType = .camera
                            addExpenseViewModel.isImagePickerPresented = true
                        }
                        Button("Photo Library") {
                            addExpenseViewModel.sourceType = .photoLibrary
                            addExpenseViewModel.isImagePickerPresented = true
                        }
                    }
                Spacer()
            }
        }
    }
    private func handleImagePicked() {
        if let image = addExpenseViewModel.image {
            expense.image = image.jpegData(compressionQuality: 1.0)
        }
    }
}

struct EditExpenseView_Preview: PreviewProvider {
    @State static var path: NavigationPath = .init()
    static var previews: some View {
        EditExpenseView(path: $path, expense: Expense(expenseName: "Expense", expenseAmount: 12.00))
    }
}
