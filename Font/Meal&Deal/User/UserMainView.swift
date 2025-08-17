//
//  UserMainView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct UserMainView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Main Page
            NavigationView {
                VStack {
                    // Header
                    HStack {
                        Text("Meal&Deal")
                            .font(.custom("Lexend-SemiBold", size: 24))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Content Area
                    Spacer()
                    
                    Text("Main Content Area")
                        .font(.custom("Lexend-Regular", size: 16))
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .background(Color.white)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
                    .font(.custom("Lexend-Regular", size: 12))
            }
            .tag(0)
            
            // My Account Page
            NavigationView {
                VStack {
                    // Header
                    HStack {
                        Text("My Account")
                            .font(.custom("Lexend-SemiBold", size: 24))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button("Sign Out") {
                            authManager.signOut()
                        }
                        .font(.custom("Lexend-Medium", size: 14))
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Content Area
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Welcome!")
                            .font(.custom("Lexend-Medium", size: 18))
                        
                        if let user = authManager.currentUser {
                            Text(user.email)
                                .font(.custom("Lexend-Regular", size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                .background(Color.white)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
                    .font(.custom("Lexend-Regular", size: 12))
            }
            .tag(1)
        }
        .accentColor(.black)
    }
}


