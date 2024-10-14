//
//  ContentView.swift
//  Chats
//
//  Created by Yaroslav on 10/14/24.
//

import SwiftUI

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
                        self.handkeAction()
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
                }
                .padding()
            }
            
            .navigationTitle(isLoginMode ? "Log In" : "Create Account here")
            .background(Color(.init(white: 0, alpha: 0.05)).ignoresSafeArea())
        }
    }
    
    private func handkeAction(){
        if isLoginMode{
            print("Should log into firebase")
        }else{
            print("Register your account throught firebase")
        }
    }
}

#Preview {
    LogInView()
}
