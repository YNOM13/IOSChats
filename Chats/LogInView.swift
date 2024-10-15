//
//  ContentView.swift
//  Chats
//
//  Created by Yaroslav on 10/14/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {
    let auth: Auth
    
    static let shared = FirebaseManager()

    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        
        super.init()
    }
}

struct LogInView: View {
    @State var isLoginMode = false
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack (spacing: 16){
                    Picker(selection: $isLoginMode, label: Text("Picker here")){
                        Text("Login").tag(true)
                        Text("Create Account").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .background(.blue)
                        .cornerRadius(5)
                                            
                    if !isLoginMode{
                        Button {
                          
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                           
                        SecureField("Password", text: $password)
                            
                    } .padding(12)
                      .background(.white)
                      .cornerRadius(15)
                   
                    Button {
                        self.handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }.background(.blue)
                    }
                    .cornerRadius(20)
                    .padding(.horizontal, 10)
                    Text(self.loginStatusMessage )
                        .foregroundColor(.red)
                }
                .padding()
            }
            
            .navigationTitle(isLoginMode ? "Log In" : "Create Account here")
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleAction(){
        if isLoginMode{
            logInUser()
        }else{
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    private func logInUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {res, err in
            if let err = err {
                self.loginStatusMessage = "Failed to logged in user: \(err)"
                return
            }
            
            self.loginStatusMessage = ("Successfully log in user \(res?.user.uid ?? "")")
        }
    }
    
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, error in
            if let err = error {
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            
            self.loginStatusMessage = ("Successfully created user \(result?.user.uid ?? "")")
        }
    }
}

#Preview {
    LogInView()
}
