import SwiftUI
import SwiftData

struct ExpenseDetailView: View {
    
    @EnvironmentObject private var addExpenseViewModel: AddExpenseViewModel
    
    @Binding var path: NavigationPath
    
    let expense: Expense
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            if let imageData = expense.image, let uiImage = UIImage(data: imageData) {
                VStack(alignment: .leading) {
                    Text("Expense Image")
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
                            ImagePicker(isPresented: $addExpenseViewModel.isImagePickerPresented, image: $addExpenseViewModel.selectedImage, sourceType: .camera)
                        } else {
                            PhotoPicker(selectedImageData: $addExpenseViewModel.selectedImageData, date: $addExpenseViewModel.date) {
                                handleImagePicked()
                            }
                        }
                    }
            }
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    expenseNameTextView
                    expenseAmountTextView
                    expenseImageMetadataView
                }
                .padding([.top, .leading])
                Spacer()
            }
            Spacer()
            
            deleteButton
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(title: Text("Are you sure you want to delete this expense?"), message: Text(addExpenseViewModel.errorMessageReason),
                  primaryButton: .destructive(Text("Delete")) {
                addExpenseViewModel.deleteExpenseItem(expense: expense)
                path.removeLast()
            },
                  secondaryButton: .cancel())
        }
    }
    
    var expenseNameTextView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Expense Name")
                .font(.title3)
                .fontWeight(.bold)
            Text(expense.expenseName)
        }
        .padding(.leading)
    }
    
    var expenseAmountTextView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Expense Amount")
                .font(.title3)
                .fontWeight(.bold)
            Text("£\(String(format: "%.2f", expense.expenseAmount))")
        }
        .padding(.leading)
    }
    
    var expenseImageMetadataView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Image Metadata")
                .font(.title3)
                .fontWeight(.bold)
            if addExpenseViewModel.geocodingInProgress {
                ProgressView("Loading Metadata....")
            } else {
                if let metadataDetails = expense.geolocationMetadata {
                    Text("Date: \(expense.expenseImageDate?.formatted(date: .abbreviated, time: .omitted) ?? Date.distantPast.formatted(date: .abbreviated, time: .omitted))")
                    Text(metadataDetails.name)
                    Text(metadataDetails.city)
                    Text(metadataDetails.country)
                    Text(metadataDetails.postalCode)
                        .padding(.bottom)
                    Text("longitude: \(metadataDetails.longitude)")
                    Text("latitude: \(metadataDetails.latitude)")
                } else {
                    Text("No Metadata Location found")
                }
            }
            
        }
        .padding(.leading)
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
        if let image = addExpenseViewModel.selectedImageData {
            expense.image = image
        }
    }
}

struct ExpenseDetailView_Preview: PreviewProvider {
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
    static var locationManager = LocationManager()
    static let sdm = SwiftDataManager(modelContext: modelContext)
    static var addExpenseViewModel = AddExpenseViewModel(swiftDataManager: sdm, locationManager: locationManager)
    static var previews: some View {
        ExpenseDetailView(path: $path, expense: Expense(expenseName: "Expense", expenseAmount: 12.00))
            .environmentObject(addExpenseViewModel)
    }
}
