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
            DiscoverView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Discover")
                        .font(.custom("Lexend-Regular", size: 12))
                }
                .tag(0)
            
            AccountView()
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

#Preview {
    UserMainView()
        .environmentObject(AuthenticationManager())
}

