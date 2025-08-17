//
//  SignInView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    let isAdmin: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo
                    Text(isAdmin ? "Meal&Deal Partner" : "Meal&Deal")
                        .font(.custom("Lexend-SemiBold", size: 28))
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        // Email Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("Enter your email", text: $email)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            SecureField("Enter your password", text: $password)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        // Sign In Button
                        Button(action: {
                            isLoading = true
                            authManager.signIn(email: email, password: password, isAdmin: isAdmin)
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                                    .font(.custom("Lexend-Medium", size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(email.isEmpty || password.isEmpty || isLoading)
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.custom("Lexend-Medium", size: 16))
                .foregroundColor(.black)
            )
        }
    }
}
