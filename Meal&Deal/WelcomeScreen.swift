//
//  WelcomeScreen.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showingSignUp = false
    @State private var showingSignIn = false
    @State private var userType: UserType = .user
    
    enum UserType {
        case user, admin
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo
                    Text("Meal&Deal")
                        .font(.custom("Lexend-SemiBold", size: 36))
                        .foregroundColor(.black)
                    
                    VStack(spacing: 20) {
                        // User Type Selector
                        HStack(spacing: 20) {
                            Button(action: {
                                userType = .user
                            }) {
                                Text("User")
                                    .font(.custom("Lexend-Medium", size: 16))
                                    .foregroundColor(userType == .user ? .white : .black)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(userType == .user ? Color.black : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                            
                            Button(action: {
                                userType = .admin
                            }) {
                                Text("Partner")
                                    .font(.custom("Lexend-Medium", size: 16))
                                    .foregroundColor(userType == .admin ? .white : .black)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(userType == .admin ? Color.black : Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                        }
                        
                        // Sign In Button
                        Button(action: {
                            showingSignIn = true
                        }) {
                            Text("Sign In")
                                .font(.custom("Lexend-Medium", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal, 40)
                        
                        // Sign Up Button
                        Button(action: {
                            showingSignUp = true
                        }) {
                            Text("Sign Up")
                                .font(.custom("Lexend-Medium", size: 18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingSignIn) {
            SignInView(isAdmin: userType == .admin)
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView(isAdmin: userType == .admin)
        }
    }
}
