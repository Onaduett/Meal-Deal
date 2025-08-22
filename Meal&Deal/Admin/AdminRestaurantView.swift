//
//  RestaurantView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 21.08.25.
//

import SwiftUI
import PhotosUI

struct RestaurantView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var restaurant: Restaurant = sampleRestaurant
    @State private var showingEditForm = false
    @State private var showingImagePicker = false
    @State private var showingImageEditor = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            RestaurantHeader()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingEditForm = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(.custom("Lexend-Medium", size: 14))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        // Restaurant Image
                        RestaurantImageView(
                            image: restaurant.image,
                            onImageTapped: {
                                if restaurant.image != nil {
                                    showingImageEditor = true
                                } else {
                                    showingImagePicker = true
                                }
                            }
                        )
                        
                        // Basic Info
                        InfoSection(title: "Basic Information") {
                            InfoRow(label: "Name", value: restaurant.name)
                            InfoRow(label: "Phone", value: restaurant.phone)
                            InfoRow(label: "Email", value: restaurant.email)
                            InfoRow(label: "Website", value: restaurant.website)
                        }
                        
                        // Address
                        InfoSection(title: "Address") {
                            InfoRow(label: "Street", value: restaurant.address.street)
                            InfoRow(label: "City", value: restaurant.address.city)
                            InfoRow(label: "Postal Code", value: restaurant.address.postalCode)
                            InfoRow(label: "Country", value: restaurant.address.country)
                        }
                        
                        // Operating Hours
                        InfoSection(title: "Operating Hours") {
                            ForEach(restaurant.operatingHours, id: \.day) { hours in
                                HStack {
                                    Text(hours.day)
                                        .font(.custom("Lexend-Medium", size: 14))
                                        .foregroundColor(.black)
                                        .frame(width: 80, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    if hours.isOpen {
                                        Text("\(hours.openTime) - \(hours.closeTime)")
                                            .font(.custom("Lexend-Regular", size: 14))
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("Closed")
                                            .font(.custom("Lexend-Regular", size: 14))
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        // Statistics
                        InfoSection(title: "Restaurant Statistics") {
                            StatRow(label: "Total Orders", value: "\(restaurant.totalOrders)")
                            StatRow(label: "Average Rating", value: String(format: "%.1f", restaurant.averageRating))
                            StatRow(label: "Total Reviews", value: "\(restaurant.totalReviews)")
                            StatRow(label: "Member Since", value: restaurant.memberSince)
                        }
                        
                        // Status Toggle
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Restaurant Status")
                                .font(.custom("Lexend-SemiBold", size: 18))
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(restaurant.isOpen ? "Currently Open" : "Currently Closed")
                                        .font(.custom("Lexend-Medium", size: 16))
                                        .foregroundColor(restaurant.isOpen ? .green : .red)
                                    
                                    Text(restaurant.isOpen ? "Accepting new orders" : "Not accepting orders")
                                        .font(.custom("Lexend-Regular", size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: Binding(
                                    get: { restaurant.isOpen },
                                    set: { restaurant.isOpen = $0 }
                                ))
                                .scaleEffect(1.2)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Sign Out Button at the bottom
                    Button(action: {
                        authManager.signOut()
                    }) {
                        Text("Sign Out")
                            .font(.custom("Lexend-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(.systemGray6))
        .sheet(isPresented: $showingEditForm) {
            EditRestaurantView(restaurant: $restaurant)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, onImageSelected: { image in
                restaurant.image = image
            })
        }
        .sheet(isPresented: $showingImageEditor) {
            if let image = restaurant.image {
                ImageEditor(image: image, onImageUpdated: { updatedImage in
                    restaurant.image = updatedImage
                })
            }
        }
    }
}

struct RestaurantImageView: View {
    let image: UIImage?
    let onImageTapped: () -> Void
    
    var body: some View {
        Button(action: onImageTapped) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(16)
                    
                    // Edit overlay
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 12))
                                Text("Edit")
                                    .font(.custom("Lexend-Medium", size: 12))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                            .padding(.trailing, 12)
                            .padding(.bottom, 12)
                        }
                    }
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                        
                        Text("Add Restaurant Photo")
                            .font(.custom("Lexend-Medium", size: 16))
                            .foregroundColor(.blue)
                        
                        Text("Tap to select image")
                            .font(.custom("Lexend-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let onImageSelected: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let result = results.first else { return }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.parent.selectedImage = image
                        self.parent.onImageSelected(image)
                    }
                }
            }
        }
    }
}

struct ImageEditor: View {
    let image: UIImage
    let onImageUpdated: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    VStack {
                        // Image editing area
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .frame(height: 300)
                            
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(scale)
                                .offset(offset)
                                .frame(height: 280)
                                .clipped()
                                .cornerRadius(16)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let delta = value / lastScaleValue
                                            lastScaleValue = value
                                            scale = min(max(scale * delta, 0.5), 3.0)
                                        }
                                        .onEnded { _ in
                                            lastScaleValue = 1.0
                                        }
                                        .simultaneously(with:
                                            DragGesture()
                                                .onChanged { value in
                                                    offset = value.translation
                                                }
                                        )
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // Controls
                        VStack(spacing: 20) {
                            // Scale slider
                            VStack(spacing: 8) {
                                HStack {
                                    Image(systemName: "minus.magnifyingglass")
                                        .foregroundColor(.white)
                                    
                                    Slider(value: $scale, in: 0.5...3.0)
                                        .accentColor(.blue)
                                    
                                    Image(systemName: "plus.magnifyingglass")
                                        .foregroundColor(.white)
                                }
                                
                                Text("Scale: \(String(format: "%.1f", scale))x")
                                    .font(.custom("Lexend-Regular", size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            // Action buttons
                            HStack(spacing: 16) {
                                Button("Reset") {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        scale = 1.0
                                        offset = .zero
                                    }
                                }
                                .font(.custom("Lexend-Medium", size: 16))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                
                                Button("More Options") {
                                    showingActionSheet = true
                                }
                                .font(.custom("Lexend-Medium", size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Edit Photo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let editedImage = applyEdits()
                    onImageUpdated(editedImage)
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.custom("Lexend-SemiBold", size: 16))
                .foregroundColor(.blue)
            )
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Photo Options"),
                buttons: [
                    .default(Text("Choose New Photo")) {
                        presentationMode.wrappedValue.dismiss()
                        // This would trigger the image picker again
                    },
                    .destructive(Text("Remove Photo")) {
                        onImageUpdated(UIImage()) // Pass empty image to indicate removal
                        presentationMode.wrappedValue.dismiss()
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private func applyEdits() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { _ in
            image.draw(at: .zero)
        }
    }
}

// Updated Restaurant struct to include image
struct Restaurant {
    var name: String
    var phone: String
    var email: String
    var website: String
    var address: Address
    var operatingHours: [OperatingHours]
    var isOpen: Bool
    var image: UIImage? // Added image property
    let totalOrders: Int
    let averageRating: Double
    let totalReviews: Int
    let memberSince: String
}

struct RestaurantHeader: View {
    var body: some View {
        HStack {
            Text("Meal&Deal Partner")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("Restaurant")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.white)
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Lexend-SemiBold", size: 18))
                .foregroundColor(.black)
            
            VStack(spacing: 8) {
                content
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Lexend-Medium", size: 14))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.custom("Lexend-Regular", size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 2)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Lexend-Medium", size: 14))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.custom("Lexend-Bold", size: 14))
                .foregroundColor(.black)
        }
        .padding(.vertical, 2)
    }
}

struct EditRestaurantView: View {
    @Binding var restaurant: Restaurant
    @Environment(\.presentationMode) var presentationMode
    @State private var editableRestaurant: Restaurant
    @State private var showingImagePicker = false
    
    init(restaurant: Binding<Restaurant>) {
        self._restaurant = restaurant
        self._editableRestaurant = State(initialValue: restaurant.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Photo section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Restaurant Photo")
                            .font(.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.black)
                        
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 120)
                                
                                if let image = editableRestaurant.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 120)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.blue)
                                        
                                        Text("Add Photo")
                                            .font(.custom("Lexend-Medium", size: 14))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Basic Info
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Basic Information")
                            .font(.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.black)
                        
                        FormField(label: "Restaurant Name", text: $editableRestaurant.name)
                        FormField(label: "Phone", text: $editableRestaurant.phone)
                        FormField(label: "Email", text: $editableRestaurant.email)
                        FormField(label: "Website", text: $editableRestaurant.website)
                    }
                    
                    // Address
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Address")
                            .font(.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.black)
                        
                        FormField(label: "Street", text: $editableRestaurant.address.street)
                        FormField(label: "City", text: $editableRestaurant.address.city)
                        FormField(label: "Postal Code", text: $editableRestaurant.address.postalCode)
                        FormField(label: "Country", text: $editableRestaurant.address.country)
                    }
                    
                    // Operating Hours
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Operating Hours")
                            .font(.custom("Lexend-SemiBold", size: 18))
                            .foregroundColor(.black)
                        
                        ForEach(editableRestaurant.operatingHours.indices, id: \.self) { index in
                            HourRow(hours: $editableRestaurant.operatingHours[index])
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("Edit Restaurant")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    restaurant = editableRestaurant
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: .constant(nil), onImageSelected: { image in
                editableRestaurant.image = image
            })
        }
    }
}

struct FormField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.custom("Lexend-Medium", size: 14))
                .foregroundColor(.black)
            
            TextField("Enter \(label.lowercased())", text: $text)
                .font(.custom("Lexend-Regular", size: 16))
                .padding(12)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

struct HourRow: View {
    @Binding var hours: OperatingHours
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(hours.day)
                    .font(.custom("Lexend-Medium", size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Toggle("Open", isOn: $hours.isOpen)
            }
            
            if hours.isOpen {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Open Time")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        TextField("09:00", text: $hours.openTime)
                            .font(.custom("Lexend-Regular", size: 14))
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Close Time")
                            .font(.custom("Lexend-Regular", size: 12))
                            .foregroundColor(.gray)
                        
                        TextField("22:00", text: $hours.closeTime)
                            .font(.custom("Lexend-Regular", size: 14))
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct Address {
    var street: String
    var city: String
    var postalCode: String
    var country: String
}

struct OperatingHours {
    let day: String
    var isOpen: Bool
    var openTime: String
    var closeTime: String
}

// Updated sample data
let sampleRestaurant = Restaurant(
    name: "Delicious Bites Restaurant",
    phone: "+49 30 12345678",
    email: "info@deliciousbites.com",
    website: "www.deliciousbites.com",
    address: Address(
        street: "FriedrichstraÃŸe 123",
        city: "Berlin",
        postalCode: "10117",
        country: "Germany"
    ),
    operatingHours: [
        OperatingHours(day: "Monday", isOpen: true, openTime: "09:00", closeTime: "22:00"),
        OperatingHours(day: "Tuesday", isOpen: true, openTime: "09:00", closeTime: "22:00"),
        OperatingHours(day: "Wednesday", isOpen: true, openTime: "09:00", closeTime: "22:00"),
        OperatingHours(day: "Thursday", isOpen: true, openTime: "09:00", closeTime: "22:00"),
        OperatingHours(day: "Friday", isOpen: true, openTime: "09:00", closeTime: "23:00"),
        OperatingHours(day: "Saturday", isOpen: true, openTime: "10:00", closeTime: "23:00"),
        OperatingHours(day: "Sunday", isOpen: false, openTime: "10:00", closeTime: "21:00")
    ],
    isOpen: true,
    image: nil, // Added image property
    totalOrders: 1247,
    averageRating: 4.6,
    totalReviews: 203,
    memberSince: "January 2023"
)

#Preview {
    RestaurantView()
        .environmentObject(AuthenticationManager())
}
