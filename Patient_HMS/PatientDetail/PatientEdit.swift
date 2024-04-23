import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
struct Profile_Edit: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var patientViewModel: PatientViewModel
    @State private var navigationLinkIsActive = false
    @State private var isImagePickerP = false
    @State private var isImagePickerPresented = false
    @State private var posterImage : UIImage?
    @State private var defaultposterImage : UIImage = UIImage(named: "default_hackathon_poster")!
  
    let genders = ["Male", "Female", "Other"]
    let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    @State private var healthRecordPDFs: [Data] = [] // Array to store PDF data
        @State private var selectedPDFName: String? = nil // Store selected PDF name
        
//        private func handlePDFSelection(result: Result<URL, Error>) {
//            if case let .success(url) = result {
//                do {
//                    // Convert PDF to Data
//                    let pdfData = try Data(contentsOf: url)
//                    healthRecordPDFs.append(pdfData)
//                    // Get selected PDF name
//                    selectedPDFName = url.lastPathComponent
//                } catch {
//                    print("Error converting PDF to data: \(error)")
//                }
//            }
//        }
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Edit Profile")) {
                    // CameraButton
                    HStack {
                        Spacer()
                        Button(action: {
                                                        isImagePickerPresented.toggle()
                                                    }) {
                                                        if let posterImage = posterImage {
                                                            Image(uiImage: posterImage)
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 100, height: 100)
                                                                .cornerRadius(10)
                                                        } else {
                                                            if let posterURL = patientViewModel.currentProfile.profilephoto {
                                                                AsyncImage(url: URL(string: posterURL)) { phase in
                                                                    switch phase {
                                                                    case .success(let image):
                                                                        image
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fill)
                                                                            .frame(width: 350, height: 200)
                                                                            .cornerRadius(20.0)
                                                                            .clipShape(Circle())
                                                                            .padding([.leading, .bottom, .trailing])
                                                                    default:
                                                                        ProgressView()
                                                                            .frame(width: 50, height: 50)
                                                                            .padding([.leading, .bottom, .trailing])
                                                                    }
                                                                }
                                                            } else {
                                                                Image(uiImage: UIImage(named: "default_hackathon_poster")!)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                                    .frame(width: 350, height: 200)
                                                                    .cornerRadius(20.0)
                                                                    .clipShape(Circle())
                                                                    .padding([.leading, .bottom, .trailing])
                                                            }
                                                        }
                                                    }
                                                    .sheet(isPresented: $isImagePickerPresented) {
                                                        ImageP(posterImage: $posterImage, defaultPoster: defaultposterImage)
                                                    }
                        Spacer()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("Full Name: ")
                        TextField("Name", text: $patientViewModel.currentProfile.fullName)
                    }
                    .padding(.bottom, 15.0)
                    
                  
                    
                    HStack {
                                Text("Mobile Number: ")
                                TextField("Enter Mobile Number", text: $patientViewModel.currentProfile.mobileno)
                                    .keyboardType(.numberPad)
                            }
                    .padding(.bottom, 15.0)
                    HStack{
                        Picker("Select Gender", selection: $patientViewModel.currentProfile.gender) {
                            ForEach(genders, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }.padding(.bottom, 15.0)
                    HStack{
                        Picker("Select Blood Group", selection: $patientViewModel.currentProfile.bloodgroup) {
                            ForEach(bloodGroups, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }.padding(.bottom, 15.0)
                    HStack {
                                Text("Emergency Contact: ")
                                TextField("Enter Emergency Contact", text: $patientViewModel.currentProfile.emergencycontact)
                                    .keyboardType(.numberPad)
                            }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        DatePicker("Date of Birth", selection: $patientViewModel.currentProfile.dob,
                                   in: Date()..., displayedComponents: [.date])
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        Text("Address: ")
                        TextField("Your Address", text: $patientViewModel.currentProfile.address)
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                                Text("Pincode: ")
                        TextField("Enter Pincode", text: $patientViewModel.currentProfile.pincode)
                                    .keyboardType(.numberPad)
                            }
                    .padding(.bottom, 15.0)
                    
                
//                    Section(header: Text("Upload Health Records")) {
//                                        Button("Upload PDF") {
//                                            // Present document picker to select PDF
//                                            isImagePickerPresented.toggle()
//                                        }
//                                        .sheet(isPresented: $isImagePickerPresented) {
//                                            DocumentPicker(documentTypes: [UTType.pdf.identifier], handleResult: handlePDFSelection)
//                                        }
//
//                                        // Display selected PDF filename
//                                        if let selectedPDFName = selectedPDFName {
//                                            Text("Uploaded PDF: \(selectedPDFName)")
//                                        }
//                                    }
                                }
            }
            
            Button(action: {
                Task {
                    
                        patientViewModel.updateProfile(patientViewModel.currentProfile, posterImage: posterImage ?? defaultposterImage, userId: viewModel.currentUser?.id) {
                        }
                    
                    
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Edit Profile")
                    .foregroundColor(.blue)
                    .padding()
            }
           
            
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create Your Profile")
        .padding(.horizontal, 7)
    }
}


