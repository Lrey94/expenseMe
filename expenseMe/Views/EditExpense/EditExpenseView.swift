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
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            if let imageData = expense.image, let uiImage = UIImage(data: imageData) {
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
            
            VStack(spacing: 15) {
                expenseNameTextView
                expenseAmountTextView
            }
            .padding(.top)
            
            Spacer()
            
            deleteButton
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Are you sure you want to delete this expense?"), message: Text(addExpenseViewModel.errorMessage),
                  primaryButton: .destructive(Text("Delete")) {
                addExpenseViewModel.deleteExpenseItem(expense: expense)
                path = NavigationPath()
            },
                  secondaryButton: .cancel())
        }
    }
    
    var expenseNameTextView: some View {
        HStack {
            Text(expense.expenseName)
                .font(.title3)
                .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 40)
        .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.7)))
    }
    
    var expenseAmountTextView: some View {
        HStack {
            Text("£\(String(format: "%.2f", expense.expenseAmount))")
                .font(.title3)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width * 0.9, height: 40)
        .background(RoundedRectangle(cornerRadius: 10).fill(.gray.opacity(0.7)))
    }
    
    var deleteButton: some View {
        Button {
            showDeleteAlert.toggle()
            
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
