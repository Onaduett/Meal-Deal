//
//  DiscoverView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 22.08.25.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    DiscoverHeader()
                    
                    VStack(spacing: 24) {
                        SearchBar()
                        
                        CategoriesSection()
                        
                        RestaurantSection()
                        
                        PickUpTodaySection()
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.white)
        }
    }
}

struct DiscoverHeader: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Meal&Deal")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(Color.white)
    }
}

struct SearchBar: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                TextField("Search Meals", text: $searchText)
                    .font(.custom("Lexend-Regular", size: 16))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(25)
        }
    }
}

struct CategoriesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Suggestions")
                    .font(.custom("Lexend-SemiBold", size: 18))
                    .foregroundColor(.black)
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                }
            }
        }
    }
}

struct RestaurantSection: View {
    let restaurants = [
        UserRestaurant(name: "Nedelka", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Magnum", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Dastarkhan", price: "1,800₸", originalPrice: "2,500₸"),
        UserRestaurant(name: "Burger King", price: "3,200₸", originalPrice: "4,000₸")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Restaurants")
                    .font(.custom("Lexend-SemiBold", size: 18))
                    .foregroundColor(.black)
                Spacer()
                NavigationLink("See all", destination: AllRestaurantsView())
                    .font(.custom("Lexend-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurants, id: \.name) { restaurant in
                        RestaurantCard(restaurant: restaurant)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct PickUpTodaySection: View {
    let pickupDeals = [
        UserRestaurant(name: "Coffee Boom", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Navat", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Starbucks", price: "1,900₸", originalPrice: "2,800₸"),
        UserRestaurant(name: "KFC", price: "2,800₸", originalPrice: "3,500₸")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("PickUp Today")
                    .font(.custom("Lexend-SemiBold", size: 18))
                    .foregroundColor(.black)
                Spacer()
                NavigationLink("See all", destination: AllPickupDealsView())
                    .font(.custom("Lexend-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(pickupDeals, id: \.name) { deal in
                        RestaurantCard(restaurant: deal)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

struct RestaurantCard: View {
    let restaurant: UserRestaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Restaurant Image Placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .frame(width: 240, height: 120)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.custom("Lexend-Medium", size: 16))
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    Text(restaurant.price)
                        .font(.custom("Lexend-SemiBold", size: 14))
                        .foregroundColor(.black)
                    
                    Text(restaurant.originalPrice)
                        .font(.custom("Lexend-Regular", size: 12))
                        .foregroundColor(.gray)
                        .strikethrough()
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 240)
    }
}

// New views for "See all" functionality
struct AllRestaurantsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let restaurants = [
        UserRestaurant(name: "Nedelka", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Magnum", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Dastarkhan", price: "1,800₸", originalPrice: "2,500₸"),
        UserRestaurant(name: "Burger King", price: "3,200₸", originalPrice: "4,000₸"),
        UserRestaurant(name: "Pizza Hut", price: "2,800₸", originalPrice: "3,800₸"),
        UserRestaurant(name: "Domino's", price: "2,500₸", originalPrice: "3,200₸")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(restaurants, id: \.name) { restaurant in
                    RestaurantCard(restaurant: restaurant)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle("All Restaurants")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(false)
    }
}

struct AllPickupDealsView: View {
    @Environment(\.dismiss) private var dismiss
    
    let pickupDeals = [
        UserRestaurant(name: "Coffee Boom", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Navat", price: "2,300₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Starbucks", price: "1,900₸", originalPrice: "2,800₸"),
        UserRestaurant(name: "KFC", price: "2,800₸", originalPrice: "3,500₸"),
        UserRestaurant(name: "Costa Coffee", price: "1,800₸", originalPrice: "2,500₸"),
        UserRestaurant(name: "McDonald's", price: "2,200₸", originalPrice: "3,000₸")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(pickupDeals, id: \.name) { deal in
                    RestaurantCard(restaurant: deal)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle("PickUp Today")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(false)
    }
}

struct UserRestaurant {
    let name: String
    let price: String
    let originalPrice: String
}

#Preview {
    DiscoverView()
}
