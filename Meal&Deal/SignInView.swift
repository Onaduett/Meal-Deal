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
    @State private var showingForgotPassword = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
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
                                .textContentType(.password)
                        }
                        
                        // Forgot Password Button
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                showingForgotPassword = true
                            }
                            .font(.custom("Lexend-Regular", size: 14))
                            .foregroundColor(.black)
                        }
                        
                        // Error Message
                        if let errorMessage = authManager.errorMessage {
                            Text(errorMessage)
                                .font(.custom("Lexend-Regular", size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Sign In Button
                        Button(action: {
                            authManager.signIn(email: email, password: password, isAdmin: isAdmin)
                        }) {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.9)
                            } else {
                                Text("Sign In")
                                    .font(.custom("Lexend-Medium", size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isFormValid ? Color.black : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .disabled(!isFormValid || authManager.isLoading)
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
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
            }
            .alert("Message", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
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
        email.contains("@") &&
        email.contains(".")
    }
}

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Reset Password")
                    .font(.custom("Lexend-SemiBold", size: 24))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .font(.custom("Lexend-Regular", size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
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
                .padding(.horizontal, 30)
                
                Button("Send Reset Link") {
                    authManager.resetPassword(email: email)
                    showingAlert = true
                }
                .font(.custom("Lexend-Medium", size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isEmailValid ? Color.black : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 30)
                .disabled(!isEmailValid)
                
                Spacer()
            }
            .background(Color.white)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.custom("Lexend-Medium", size: 16))
                .foregroundColor(.black)
            )
            .alert("Password Reset", isPresented: $showingAlert) {
                Button("OK") {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("If an account with that email exists, we've sent you a password reset link.")
            }
        }
    }
    
    private var isEmailValid: Bool {
        !email.isEmpty && email.contains("@") && email.contains(".")
    }
}
