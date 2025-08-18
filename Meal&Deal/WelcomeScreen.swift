//
//  WelcomeScreen.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var userType: UserType = .user
    @State private var authState: AuthState = .enterEmail
    @State private var isCheckingUser = false
    
    enum UserType {
        case user, admin
    }
    
    enum AuthState {
        case enterEmail
        case signIn
        case signUp
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: {
                            userType = userType == .user ? .admin : .user
                        }) {
                            Text(userType == .admin ? "User" : "Partner")
                                .font(.custom("Lexend-Medium", size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        // Logo
                        Text("Meal&Deal")
                            .font(.custom("Lexend-SemiBold", size: 48))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 20) {
                            // Subtitle
                            Text(authState == .enterEmail ? "Log in or Sign up" : (authState == .signIn ? "Welcome back!" : "Create your account"))
                                .font(.custom("Lexend-Medium", size: 18))
                                .foregroundColor(.black)
                            
                            VStack(spacing: 16) {
                                // Email Field
                                VStack(alignment: .leading, spacing: 8) {
                                    if authState != .enterEmail {
                                        Text("Email")
                                            .font(.custom("Lexend-Medium", size: 14))
                                            .foregroundColor(.black)
                                    }
                                    
                                    TextField(authState == .enterEmail ? "Email" : "Enter your email", text: $email)
                                        .font(.custom("Lexend-Regular", size: 16))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                        .background(Color.gray.opacity(0.05))
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(.gray.opacity(0.3))
                                                .padding(.horizontal, 16),
                                            alignment: .bottom
                                        )
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .textContentType(.emailAddress)
                                        .disabled(authState != .enterEmail)
                                }
                                
                                if authState == .signIn || authState == .signUp {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(authState == .signIn ? "Password" : "Create a password")
                                            .font(.custom("Lexend-Medium", size: 14))
                                            .foregroundColor(.black)
                                        
                                        SecureField("Enter your password", text: $password)
                                            .font(.custom("Lexend-Regular", size: 16))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 16)
                                            .background(Color.gray.opacity(0.05))
                                            .overlay(
                                                Rectangle()
                                                    .frame(height: 1)
                                                    .foregroundColor(.gray.opacity(0.3))
                                                    .padding(.horizontal, 16),
                                                alignment: .bottom
                                            )
                                            .textContentType(authState == .signUp ? .newPassword : .password)
                                        
                                        if authState == .signUp {
                                            Text("Password must be at least 6 characters")
                                                .font(.custom("Lexend-Regular", size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                                }
                                
                                if let errorMessage = authManager.errorMessage {
                                    Text(errorMessage)
                                        .font(.custom("Lexend-Regular", size: 14))
                                        .foregroundColor(.red)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            
                            // Continue Button
                            Button(action: handleContinue) {
                                if authManager.isLoading || isCheckingUser {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Text(getContinueButtonText())
                                        .font(.custom("Lexend-Medium", size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isContinueButtonEnabled ? Color.black : Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .disabled(!isContinueButtonEnabled || authManager.isLoading || isCheckingUser)
                            .padding(.horizontal, 20)
                            
                            // Back button for password states
                            if authState != .enterEmail {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        authState = .enterEmail
                                        password = ""
                                        authManager.errorMessage = nil
                                    }
                                }) {
                                    Text("← Back to email")
                                        .font(.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // Social Login (only show in email state)
                            if authState == .enterEmail {
                                VStack(spacing: 16) {
                                    // Divider
                                    HStack {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.gray.opacity(0.3))
                                        
                                        Text("or use")
                                            .font(.custom("Lexend-Regular", size: 14))
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 16)
                                        
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.gray.opacity(0.3))
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    // Social Login Buttons
                                    HStack(spacing: 12) {
                                        // Google Sign In
                                        Button(action: {
                                            // Handle Google sign in
                                            authManager.signInWithGoogle(isAdmin: userType == .admin)
                                        }) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "globe")
                                                    .foregroundColor(.black)
                                                Text("Sign in with Google")
                                                    .font(.custom("Lexend-Medium", size: 14))
                                                    .foregroundColor(.black)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                        
                                        // Apple Sign In
                                        Button(action: {
                                            // Handle Apple sign in
                                            authManager.signInWithApple(isAdmin: userType == .admin)
                                        }) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "applelogo")
                                                    .foregroundColor(.black)
                                                Text("Sign in with Apple")
                                                    .font(.custom("Lexend-Medium", size: 14))
                                                    .foregroundColor(.black)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 44)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .transition(.asymmetric(
                                    insertion: .opacity,
                                    removal: .opacity
                                ))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Terms and conditions (only show in signup state)
                    if authState == .signUp {
                        Text("By signing up, you agree to our Terms of Service and Privacy Policy")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 20)
                            .transition(.opacity)
                    }
                }
            }
        }
        .onAppear {
            authManager.errorMessage = nil
        }
        .animation(.easeInOut(duration: 0.3), value: authState)
    }
    
    private func handleContinue() {
        switch authState {
        case .enterEmail:
            checkUserExists()
        case .signIn:
            authManager.signIn(email: email, password: password, isAdmin: userType == .admin)
        case .signUp:
            authManager.signUp(email: email, password: password, isAdmin: userType == .admin)
        }
    }
    
    private func checkUserExists() {
        guard isValidEmail(email) else {
            authManager.errorMessage = "Please enter a valid email address"
            return
        }
        
        isCheckingUser = true
        authManager.errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isCheckingUser = false
            
            // For demo purposes, assume user exists if email contains "existing"
            // In real app, this would be an API call to check user existence
            let userExists = email.lowercased().contains("existing") || email.lowercased().contains("test")
            
            withAnimation(.easeInOut(duration: 0.3)) {
                authState = userExists ? .signIn : .signUp
            }
        }
    }
    
    private func getContinueButtonText() -> String {
        switch authState {
        case .enterEmail:
            return "Continue"
        case .signIn:
            return "Sign In"
        case .signUp:
            return "Create Account"
        }
    }
    
    private var isContinueButtonEnabled: Bool {
        switch authState {
        case .enterEmail:
            return isValidEmail(email)
        case .signIn:
            return isValidEmail(email) && !password.isEmpty
        case .signUp:
            return isValidEmail(email) && password.count >= 6
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        return !email.isEmpty && email.contains("@") && email.contains(".")
    }
}

