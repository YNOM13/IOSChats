//
//  ContentView.swift
//  Chats
//
//  Created by Yaroslav on 10/14/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()
    
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}

struct LogInView: View {
    @State var isLoginMode = false
    @State var email: String = ""
    @State var password: String = ""
    @State var shouldShowImagePicker = false
    @State var imageSelection: PhotosPickerItem? = nil
    @State var uiImage: UIImage? = nil
    @State var loginStatusMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login").tag(true)
                        Text("Creatрe Account").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.blue)
                    .cornerRadius(5)
                    
                    if !isLoginMode {
                        ImagePicker(
                            shouldShowImagePicker: $shouldShowImagePicker,
                            imageSelection: $imageSelection,
                            uiImage: $uiImage
                        )
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        .background(Color.blue)
                    }
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    
                    Text(loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            logInUser()
        } else {
            createNewAccount()
        }
    }
    
    private func logInUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { res, err in
            if let err = err {
                loginStatusMessage = "Failed to log in user: \(err)"
                return
            }
            loginStatusMessage = "Successfully logged in user \(res?.user.uid ?? "")"
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            loginStatusMessage = "Successfully created user \(result?.user.uid ?? "")"
        }
        self.persistImageToStorage()
        
    }
    
    private func persistImageToStorage(){
//        let fileName = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = self.uiImage?.jpegData(compressionQuality: 0.5) else { return }
        
        ref.putData(imageData, metadata: nil){
            metadata, err in
            
            if let err = err {
                self.loginStatusMessage = "Failed to push image to storage \(err)"
                return
            }
            
            ref.downloadURL {  url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to download url \(err)"
                    return
                }
                
                self.loginStatusMessage = "Success: \(url?.absoluteString ?? "")"
                
                if let url = url{
                    storeUserInformation(imageProfileUrl: url)
                }else{
                    return
                }
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": self.email, "uid": uid, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) {err in
                print(err)
                self.loginStatusMessage = "\(err)"
                return
            }
            print("Success")
            
    }
}

#Preview {
    LogInView()
}
