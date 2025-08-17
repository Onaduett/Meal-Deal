//
//  Components.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var currentUser: User?
    
    func signIn(email: String, password: String, isAdmin: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            self.isAdmin = isAdmin
            self.currentUser = User(email: email, isAdmin: isAdmin)
        }
    }
    
    func signUp(email: String, password: String, isAdmin: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isAuthenticated = true
            self.isAdmin = isAdmin
            self.currentUser = User(email: email, isAdmin: isAdmin)
        }
    }
    
    func signOut() {
        isAuthenticated = false
        isAdmin = false
        currentUser = nil
    }
}
