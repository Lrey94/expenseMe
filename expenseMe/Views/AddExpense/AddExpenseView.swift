//
//  AddExpenseView.swift
//  expenseMe
//
//  Created by Lawrence Reynolds on 08/04/2024
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddExpenseView: View {
    
    @EnvironmentObject private var addExpenseViewModel: AddExpenseViewModel
    
    static let tag = NavigationDestination.addExpense
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if let image = addExpenseViewModel.image {
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading) {
                        Text("Your Chosen Image")
                            .fontWeight(.bold)
                            .font(.title3)
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    Button(action: {
                        withAnimation {
                            addExpenseViewModel.image = nil
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
                            PhotoPicker(selectedImage: $addExpenseViewModel.image, date: $addExpenseViewModel.date, location: $addExpenseViewModel.location) {
                                
                            }
                        }
                    }
            }
            
            AddExpenseNameTextField(text: "Enter expense name")
            AddExpenseAmountTextField(text: "Enter expense amount")
            
            saveButton
            
            Spacer()
        }
        .alert(isPresented: $addExpenseViewModel.showErrorMessage) {
            Alert(title: Text("Error!"), message: Text(addExpenseViewModel.errorMessage),
                  dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            print("onAppear: \(path.count)")
        }
    }
    
    var saveButton: some View {
        Button {
            addExpenseViewModel.addExpenseItem()
            path.removeLast()
        } label: {
            HStack {
                Image(systemName: "checkmark")
                Text("Save")
            }
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(width: 200, height: 40)
            .background(RoundedRectangle(cornerRadius: 10).fill(.green))
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
}

struct AddExpenseNameTextField: View {
    
    @EnvironmentObject private var viewModel: AddExpenseViewModel
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Expense Name")
                .fontWeight(.semibold)
            TextField(text, text: $viewModel.expenseName)
                .textFieldStyle(.roundedBorder)
        }
        .padding([.leading, .top])
    }
}

struct AddExpenseAmountTextField: View {
    
    @EnvironmentObject private var viewModel: AddExpenseViewModel
    
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Expense Amount")
                .fontWeight(.semibold)
            TextField(text, value: $viewModel.expenseAmount, format: .number)
                .textFieldStyle(.roundedBorder)
        }
        .padding([.leading, .top])
    }
}

struct AddExpenseView_Preview: PreviewProvider {
    @State static var path: NavigationPath = .init()
    static var modelContext: ModelContext = {
        do {
            let modelContainer = try ModelContainer(for: Expense.self)
            return modelContainer.mainContext
        } catch {
            print(error)
            fatalError("Unable to create modelContainer: \(error)")
        }
    }()
    static var addExpenseViewModel = AddExpenseViewModel(modelContext: modelContext)
    
    static var previews: some View {
        VStack {
            AddExpenseView(path: $path)
                .environmentObject(addExpenseViewModel)
        }
    }
}
