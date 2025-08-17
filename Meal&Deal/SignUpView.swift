//
//  SignUpView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
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
                                .textContentType(.emailAddress)
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
                                .textContentType(.newPassword)
                            
                            // Password requirements
                            Text("Password must be at least 6 characters")
                                .font(.custom("Lexend-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        // Confirm Password Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            SecureField("Confirm your password", text: $confirmPassword)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .textContentType(.newPassword)
                            
                            // Password match indicator
                            if !confirmPassword.isEmpty {
                                HStack {
                                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(password == confirmPassword ? .green : .red)
                                    Text(password == confirmPassword ? "Passwords match" : "Passwords don't match")
                                        .font(.custom("Lexend-Regular", size: 12))
                                        .foregroundColor(password == confirmPassword ? .green : .red)
                                }
                            }
                        }
                        
                        // Error Message
                        if let errorMessage = authManager.errorMessage {
                            Text(errorMessage)
                                .font(.custom("Lexend-Regular", size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Sign Up Button
                        Button(action: {
                            if password != confirmPassword {
                                authManager.errorMessage = "Passwords do not match"
                                return
                            }
                            authManager.signUp(email: email, password: password, isAdmin: isAdmin)
                        }) {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                            } else {
                                Text("Sign Up")
                                    .font(.custom("Lexend-Medium", size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isFormValid ? Color.black : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(!isFormValid || authManager.isLoading)
                        
                        // Terms and Conditions
                        Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
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
            .alert("Success", isPresented: $showingAlert) {
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Account created successfully! Please check your email to verify your account.")
            }
        }
        .onChange(of: authManager.isAuthenticated) { authenticated in
            if authenticated {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            authManager.errorMessage = nil
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 6 &&
        email.contains("@") &&
        email.contains(".")
    }
}
