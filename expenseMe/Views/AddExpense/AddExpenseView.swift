import SwiftUI
import PhotosUI
import SwiftData

struct AddExpenseView: View {
    
    @EnvironmentObject private var addExpenseViewModel: AddExpenseViewModel
    
    static let tag = NavigationDestination.addExpense
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if let imageData = addExpenseViewModel.selectedImageData {
                let uiImage = UIImage(data: imageData)
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading) {
                        Text("Your Chosen Image")
                            .fontWeight(.bold)
                            .font(.title3)
                        if let image = uiImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                        }
                    }
                    Button(action: {
                        withAnimation {
                            addExpenseViewModel.selectedImageData = nil
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
                            ImagePicker(isPresented: $addExpenseViewModel.isImagePickerPresented, image: $addExpenseViewModel.selectedImage, sourceType: .camera)
                        } else {
                            PhotoPicker(selectedImageData: $addExpenseViewModel.selectedImageData, date: $addExpenseViewModel.date) {
                                
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
            Alert(title: Text(addExpenseViewModel.errorMessageReason), message: Text(addExpenseViewModel.errorMessageRecoverySuggestion),
                  dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            addExpenseViewModel.resetExpenseData()
        }
    }
    
    var saveButton: some View {
        Button {
            addExpenseViewModel.addExpenseItem() { success in
                if success {
                    if !path.isEmpty {
                        path.removeLast()
                    }
                }
            }
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
                            addExpenseViewModel.presentPhotoPicker()
                        }
                        Button("Photo Library") {
                            addExpenseViewModel.sourceType = .photoLibrary
                            addExpenseViewModel.presentPhotoPicker()
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
                .background(.white)
                .overlay (
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.addExpenseErrorBorder == .expenseName ? .red : .gray.opacity(0.5), lineWidth: 2)
                )
        }
        .padding([.horizontal, .top])
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
                .background(.white)
                .overlay (
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.addExpenseErrorBorder == .expenseAmount ? .red : .gray.opacity(0.5), lineWidth: 2)
                )
        }
        .padding([.horizontal, .top])
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
    static let lm = LocationManager()
    static let sdm = SwiftDataManager(modelContext: modelContext)
    static var addExpenseViewModel = AddExpenseViewModel(swiftDataManager: sdm, locationManager: lm)
    static var previews: some View {
        VStack {
            AddExpenseView(path: $path)
                .environmentObject(addExpenseViewModel)
        }
    }
}
