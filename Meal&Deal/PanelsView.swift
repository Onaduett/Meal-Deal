//
//  ContentView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI



struct PanelsView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                if authManager.isAdmin {
                    AdminPanelView()
                } else {
                    UserMainView()
                }
            } else {
                WelcomeView()
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    PanelsView()
}
