//
//  AdminMainView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 21.08.25.
//

import SwiftUI

struct AdminPanelView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab: AdminTab = .dashboard
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .dashboard:
                    DashboardView()
                        .environmentObject(authManager)
                case .orders:
                    OrdersView()
                case .boxes:
                    BoxesView()
                case .restaurant:
                    RestaurantView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            BottomTabNavigation(selectedTab: $selectedTab)
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct TopNavigationBar: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
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
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.white)
    }
}

struct BottomTabNavigation: View {
    @Binding var selectedTab: AdminTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AdminTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 20, weight: .medium))
                        
                        Text(tab.title)
                            .font(.custom("Lexend-Medium", size: 11))
                    }
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)

                }
            }
        }
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: -1)
        .ignoresSafeArea(edges: .bottom)
    }
}

enum AdminTab: String, CaseIterable {
    case dashboard = "Dashboard"
    case orders = "Orders"
    case boxes = "Boxes"
    case restaurant = "Restaurant"
    
    var title: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .dashboard:
            return "chart.bar.fill"
        case .orders:
            return "bag.fill"
        case .boxes:
            return "shippingbox.fill"
        case .restaurant:
            return "building.2.fill"
        }
    }
}

#Preview {
    AdminPanelView()
        .environmentObject(AuthenticationManager())
}
