//
//  Components.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import Foundation
import Supabase
import SwiftUI

class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        let supabaseURL = URL(string: "https://fmnldspncgwsgkoqdlfq.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZtbmxkc3BuY2d3c2drb3FkbGZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU0NDIxMTksImV4cCI6MjA3MTAxODExOX0.Oz-S-6oCi4PGj5n-3ewF4uOnLeUav18OzrM81rTS3Y4"
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
    }
}

enum AuthError: Error, LocalizedError {
    case invalidEmail
    case weakPassword
    case passwordMismatch
    case networkError(String)
    case unknownError
    case userNotFound
    case wrongUserType
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 6 characters long"
        case .passwordMismatch:
            return "Passwords do not match"
        case .networkError(let message):
            return "Network error: \(message)"
        case .unknownError:
            return "An unknown error occurred"
        case .userNotFound:
            return "No account found with this email address"
        case .wrongUserType:
            return "This account type doesn't match your selection"
        }
    }
}

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let supabase = SupabaseManager.shared.client
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        Task {
            do {
                let session = try await supabase.auth.session
                await MainActor.run {
                    self.handleAuthenticatedUser(session.user)
                }
            } catch {
                await MainActor.run {
                    self.isAuthenticated = false
                    self.currentUser = nil
                    self.isAdmin = false
                }
            }
        }
    }
    
    func signIn(email: String, password: String, isAdmin: Bool = false) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                let session = try await supabase.auth.signIn(email: email, password: password)
                
                let userProfile = try await fetchUserProfile(userId: session.user.id)
                
                await MainActor.run {
                    // Check if the user type matches what they selected
                    if isAdmin != userProfile.isAdmin {
                        self.errorMessage = isAdmin ? "This account is not registered as a partner" : "This account is registered as a partner"
                        self.isLoading = false
                        // Sign out the user since they selected wrong type
                        Task {
                            try? await self.supabase.auth.signOut()
                        }
                        return
                    }
                    
                    self.isAuthenticated = true
                    self.isAdmin = userProfile.isAdmin
                    self.currentUser = userProfile
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Sign Up
    func signUp(email: String, password: String, isAdmin: Bool = false) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                try validateSignUpInput(email: email, password: password)
                let authResponse = try await supabase.auth.signUp(email: email, password: password)
                
                let user = authResponse.user
                try await createUserProfile(userId: user.id, email: email, isAdmin: isAdmin)
                
                await MainActor.run {
                    if authResponse.session != nil {
                        self.isAuthenticated = true
                        self.isAdmin = isAdmin
                        self.currentUser = User(id: user.id, email: email, isAdmin: isAdmin, createdAt: Date())
                    } else {
                        self.errorMessage = "Please check your email to verify your account"
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    if let authError = error as? AuthError {
                        self.errorMessage = authError.localizedDescription
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    // Sign Out
    func signOut() {
        Task {
            do {
                try await supabase.auth.signOut()
                await MainActor.run {
                    self.isAuthenticated = false
                    self.isAdmin = false
                    self.currentUser = nil
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Reset Password
    func resetPassword(email: String) {
        Task {
            do {
                try await supabase.auth.resetPasswordForEmail(email)
                await MainActor.run {
                    self.errorMessage = "Password reset email sent"
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Check if user exists in Supabase Auth (not just the users table)
    func checkUserExists(email: String) async throws -> Bool {
        do {
            let response: [User] = try await supabase.database
                .from("users")
                .select("id, email, is_admin")
                .eq("email", value: email)
                .execute()
                .value
            
            if !response.isEmpty {
                return true
            }
            
            return false
            
        } catch {
            print("Error checking user existence: \(error)")
            return false
        }
    }
    
    // Social Login Methods
    func signInWithGoogle(isAdmin: Bool) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                // TODO: Implement Google Sign In with Supabase OAuth
                // You'll need to configure Google OAuth in your Supabase dashboard
                // and then use something like:
                /*
                try await supabase.auth.signInWithOAuth(
                    provider: .google,
                    redirectTo: URL(string: "your-app-scheme://oauth-callback")
                )
                */
                
                // For now, show a placeholder message
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Google Sign In will be implemented soon"
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signInWithApple(isAdmin: Bool) {
        Task {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }
            
            do {
                // TODO: Implement Apple Sign In with Supabase OAuth
                // You'll need to configure Apple OAuth in your Supabase dashboard
                // and then use something like:
                /*
                try await supabase.auth.signInWithOAuth(
                    provider: .apple,
                    redirectTo: URL(string: "your-app-scheme://oauth-callback")
                )
                */

                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = "Apple Sign In will be implemented soon"
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
        
    private func validateSignUpInput(email: String, password: String) throws {
        if !email.contains("@") || !email.contains(".") {
            throw AuthError.invalidEmail
        }
        
        if password.count < 6 {
            throw AuthError.weakPassword
        }
    }
    
    private func handleAuthenticatedUser(_ authUser: Supabase.User) {
        Task {
            do {
                let userProfile = try await fetchUserProfile(userId: authUser.id)
                await MainActor.run {
                    self.isAuthenticated = true
                    self.isAdmin = userProfile.isAdmin
                    self.currentUser = userProfile
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func createUserProfile(userId: UUID, email: String, isAdmin: Bool) async throws {
        struct UserProfile: Codable {
            let id: String
            let email: String
            let is_admin: Bool
            let created_at: String
        }
        
        let userProfile = UserProfile(
            id: userId.uuidString,
            email: email,
            is_admin: isAdmin,
            created_at: ISO8601DateFormatter().string(from: Date())
        )
        
        try await supabase.database
            .from("users")
            .insert(userProfile)
            .execute()
    }
    
    private func fetchUserProfile(userId: UUID) async throws -> User {
        let response: [User] = try await supabase.database
            .from("users")
            .select()
            .eq("id", value: userId.uuidString)
            .execute()
            .value
        
        guard let user = response.first else {
            throw AuthError.unknownError
        }
        
        return user
    }
}

