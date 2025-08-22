//
//  AccountView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 22.08.25.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            VStack {
                AccountHeader()
                
                Spacer()
                
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                        
                        Text("Welcome!")
                            .font(.custom("Lexend-Medium", size: 20))
                            .foregroundColor(.black)
                        
                        if let user = authManager.currentUser {
                            Text(user.email)
                                .font(.custom("Lexend-Regular", size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Account Options
                    VStack(spacing: 12) {
                        AccountOptionRow(
                            icon: "heart.fill",
                            title: "Favorite Deals",
                            action: {
                                // Handle favorites
                            }
                        )
                        
                        AccountOptionRow(
                            icon: "clock.fill",
                            title: "Order History",
                            action: {
                                // Handle order history
                            }
                        )
                        
                        AccountOptionRow(
                            icon: "gearshape.fill",
                            title: "Settings",
                            action: {
                                // Handle settings
                            }
                        )
                        
                        AccountOptionRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            action: {
                                // Handle support
                            }
                        )
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .background(Color.white)
        }
    }
}

struct AccountOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .frame(width: 24)
                
                Text(title)
                    .font(.custom("Lexend-Regular", size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.05))
            )
        }
    }
}

struct AccountHeader: View {
    var body: some View {
        HStack {
            Text("Meal&Deal")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.top, 0)
                .padding(.bottom, 10)
                .background(Color.white)
        }
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthenticationManager())
}
