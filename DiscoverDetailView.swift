//
//  RestaurantDetailView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 22.08.25.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurant: UserRestaurant
    @StateObject private var boxManager = RestaurantBoxManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    RestaurantDetailHeader(restaurant: restaurant)
                    
                    VStack(spacing: 24) {
                        RestaurantInfoSection(restaurant: restaurant)
                        
                        MealBoxesSection(
                            restaurant: restaurant,
                            boxManager: boxManager
                        )
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .refreshable {
                boxManager.refreshBoxes(for: restaurant.name)
            }
        }
    }
}

struct RestaurantDetailHeader: View {
    let restaurant: UserRestaurant
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(restaurant.name)
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.black)
            
            Spacer()
            
            // Placeholder for balance with back button
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(Color.white)
    }
}

struct RestaurantInfoSection: View {
    let restaurant: UserRestaurant
    
    var body: some View {
        VStack(spacing: 16) {
            // Restaurant Image
            ZStack {
                if let imageUrl = restaurant.imageUrl, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 200)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.8)
                            )
                    }
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "storefront")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("No Image")
                                    .font(.custom("Lexend-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                        )
                }
                
                // Status indicator overlay
                VStack {
                    HStack {
                        Spacer()
                        
                        Circle()
                            .fill(restaurant.isOpen ? Color.green : Color.red)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                            )
                    }
                    Spacer()
                }
                .padding(12)
            }
            
            // Restaurant Details
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .font(.custom("Lexend-SemiBold", size: 24))
                            .foregroundColor(.black)
                        
                        Text(restaurant.isOpen ? "Open now" : "Closed")
                            .font(.custom("Lexend-Regular", size: 14))
                            .foregroundColor(restaurant.isOpen ? .green : .red)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.orange)
                            
                            Text(String(format: "%.1f", restaurant.rating))
                                .font(.custom("Lexend-SemiBold", size: 16))
                                .foregroundColor(.black)
                        }
                        
                        Text("Rating")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Average Order")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        Text(restaurant.price)
                            .font(.custom("Lexend-SemiBold", size: 16))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Delivery Time")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        Text("20-30 min")
                            .font(.custom("Lexend-SemiBold", size: 16))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MealBoxesSection: View {
    let restaurant: UserRestaurant
    @ObservedObject var boxManager: RestaurantBoxManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Meal Boxes")
                    .font(.custom("Lexend-SemiBold", size: 18))
                    .foregroundColor(.black)
                Spacer()
            }
            
            if boxManager.isLoading {
                HStack {
                    Spacer()
                    ProgressView("Loading meal boxes...")
                        .font(.custom("Lexend-Regular", size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.vertical, 40)
            } else if let errorMessage = boxManager.errorMessage {
                VStack(spacing: 8) {
                    Text("Failed to load meal boxes")
                        .font(.custom("Lexend-Medium", size: 16))
                        .foregroundColor(.red)
                    
                    Text(errorMessage)
                        .font(.custom("Lexend-Regular", size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        boxManager.refreshBoxes(for: restaurant.name)
                    }
                    .font(.custom("Lexend-Medium", size: 14))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.vertical, 20)
            } else if boxManager.displayBoxes.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No meal boxes available")
                        .font(.custom("Lexend-Medium", size: 16))
                        .foregroundColor(.gray)
                    
                    Text("Check back later for new meal boxes")
                        .font(.custom("Lexend-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(boxManager.displayBoxes) { box in
                        RestaurantMealBoxCard(box: box)
                    }
                }
            }
        }
    }
}

struct RestaurantMealBoxCard: View {
    let box: RestaurantMealBox
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Box Image
            ZStack {
                if let imageData = box.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        )
                }
                
                // Availability status
                if !box.isAvailable {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.6))
                        .frame(height: 120)
                        .overlay(
                            Text("Unavailable")
                                .font(.custom("Lexend-SemiBold", size: 14))
                                .foregroundColor(.white)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(box.name)
                    .font(.custom("Lexend-SemiBold", size: 14))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(box.description)
                    .font(.custom("Lexend-Regular", size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                HStack(spacing: 6) {
                    Text("₸\(Int(box.price))")
                        .font(.custom("Lexend-SemiBold", size: 14))
                        .foregroundColor(.black)
                    
                    Text("₸\(Int(box.originalPrice))")
                        .font(.custom("Lexend-Regular", size: 12))
                        .foregroundColor(.gray)
                        .strikethrough()
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                        .foregroundColor(.orange)
                    
                    Text(String(format: "%.1f", box.rating))
                        .font(.custom("Lexend-Regular", size: 10))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if box.isAvailable {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        
                        Text("Available")
                            .font(.custom("Lexend-Medium", size: 8))
                            .foregroundColor(.green)
                    } else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text("Unavailable")
                            .font(.custom("Lexend-Medium", size: 8))
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .opacity(box.isAvailable ? 1.0 : 0.7)
    }
}

// MARK: - Data Manager

class RestaurantBoxManager: ObservableObject {
    @Published var displayBoxes: [RestaurantMealBox] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadInitialBoxes()
    }
    
    private func loadInitialBoxes() {
        // Simulate initial data loading
        displayBoxes = sampleRestaurantBoxes
    }
    
    func refreshBoxes(for restaurantName: String) {
        isLoading = true
        errorMessage = nil
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // In a real app, this would fetch boxes for the specific restaurant
            self.displayBoxes = sampleRestaurantBoxes
        }
    }
}

// MARK: - Models

struct RestaurantMealBox: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let originalPrice: Double
    var isAvailable: Bool
    var imageData: Data?
    let rating: Double
    
    init(name: String, description: String, price: Double, originalPrice: Double, isAvailable: Bool, rating: Double = 4.5, imageData: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.price = price
        self.originalPrice = originalPrice
        self.isAvailable = isAvailable
        self.imageData = imageData
        self.rating = rating
    }
}

// Sample Data
let sampleRestaurantBoxes: [RestaurantMealBox] = [
    RestaurantMealBox(
        name: "Premium Lunch Box",
        description: "Grilled chicken, quinoa, roasted vegetables, and house sauce",
        price: 2300,
        originalPrice: 3500,
        isAvailable: true,
        rating: 4.8
    ),
    RestaurantMealBox(
        name: "Healthy Salmon Box",
        description: "Fresh salmon, brown rice, steamed broccoli, and lemon dressing",
        price: 2800,
        originalPrice: 4200,
        isAvailable: true,
        rating: 4.6
    ),
    RestaurantMealBox(
        name: "Vegetarian Delight",
        description: "Mixed vegetables, quinoa, hummus, and tahini sauce",
        price: 1800,
        originalPrice: 2500,
        isAvailable: false,
        rating: 4.3
    ),
    RestaurantMealBox(
        name: "Protein Power Box",
        description: "Beef strips, rice, mixed greens, and protein sauce",
        price: 3200,
        originalPrice: 4000,
        isAvailable: true,
        rating: 4.9
    ),
    RestaurantMealBox(
        name: "Mediterranean Box",
        description: "Chicken shawarma, rice, vegetables, and garlic sauce",
        price: 2100,
        originalPrice: 3000,
        isAvailable: true,
        rating: 4.4
    ),
    RestaurantMealBox(
        name: "Asian Fusion Box",
        description: "Teriyaki chicken, jasmine rice, vegetables, and teriyaki sauce",
        price: 2400,
        originalPrice: 3300,
        isAvailable: true,
        rating: 4.7
    )
]

#Preview {
    RestaurantDetailView(
        restaurant: UserRestaurant(
            name: "Sample Restaurant",
            price: "2,300₸",
            originalPrice: "3,500₸",
            rating: 4.5,
            isOpen: true        )
    )
}
