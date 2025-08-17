//
//  AdminMainView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct AdminPanelView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Meal&Deal Partner")
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
                    Text("Partner Dashboard")
                        .font(.custom("Lexend-Medium", size: 18))
                    
                    if let user = authManager.currentUser {
                        Text(user.email)
                            .font(.custom("Lexend-Regular", size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Text("Admin panel content will be here")
                        .font(.custom("Lexend-Regular", size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .background(Color.white)
        }
    }
}
