//
//  DashboardView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 21.08.25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        VStack(spacing: 0) {
            DashboardHeader()
            
            ScrollView {
                VStack(spacing: 20) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(title: "Today's Orders", value: "24", icon: "bag.fill", color: .blue)
                        StatCard(title: "Revenue", value: "$1,248", icon: "dollarsign.circle.fill", color: .green)
                        StatCard(title: "Active Boxes", value: "8", icon: "shippingbox.fill", color: .orange)
                        StatCard(title: "Reviews", value: "4.8★", icon: "star.fill", color: .yellow)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(.custom("Lexend-Medium", size: 20))
                            .foregroundColor(.black)
                        
                        VStack(spacing: 12) {
                            ActivityRow(title: "New order received", subtitle: "Order #1234", time: "2 min ago")
                            ActivityRow(title: "Box delivered", subtitle: "Premium Box", time: "15 min ago")
                            ActivityRow(title: "Review posted", subtitle: "5 stars", time: "1 hour ago")
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                Spacer()
            }
            
            Text(value)
                .font(.custom("Lexend-Bold", size: 24))
                .foregroundColor(.black)
            
            Text(title)
                .font(.custom("Lexend-Regular", size: 14))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ActivityRow: View {
    let title: String
    let subtitle: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Lexend-Medium", size: 16))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.custom("Lexend-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(time)
                .font(.custom("Lexend-Regular", size: 12))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

struct DashboardHeader: View {
    var body: some View {
        HStack {
            Text("Meal&Deal Partner")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("Dashboard")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.white)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthenticationManager())
}
