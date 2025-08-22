//
//  BoxesView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 21.08.25.
//

import SwiftUI
import PhotosUI

struct BoxesView: View {
    @State private var boxes: [MealBox] = sampleBoxes
    @State private var showingAddBox = false
    @State private var editingBox: MealBox?
    
    var body: some View {
        VStack(spacing: 0) {
            BoxesHeader()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Title and Add Button
                    HStack {
                        Text("Meal Boxes")
                            .font(.custom("Lexend-SemiBold", size: 28))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddBox = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                Text("Add Box")
                            }
                            .font(.custom("Lexend-Medium", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Boxes Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(boxes) { box in
                            BoxCard(
                                box: box,
                                onToggleAvailability: { toggleBoxAvailability(box) },
                                onEdit: { editingBox = box },
                                onDelete: { deleteBox(box) }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(.systemGray6))
        .sheet(isPresented: $showingAddBox) {
            AddBoxView { newBox in
                boxes.append(newBox)
            }
        }
        .sheet(item: $editingBox) { box in
            EditBoxView(box: box) { updatedBox in
                updateBox(updatedBox)
            }
        }
    }
    
    private func toggleBoxAvailability(_ box: MealBox) {
        if let index = boxes.firstIndex(where: { $0.id == box.id }) {
            boxes[index].isAvailable.toggle()
        }
    }
    
    private func updateBox(_ updatedBox: MealBox) {
        if let index = boxes.firstIndex(where: { $0.id == updatedBox.id }) {
            boxes[index] = updatedBox
        }
    }
    
    private func deleteBox(_ box: MealBox) {
        boxes.removeAll { $0.id == box.id }
    }
}

struct BoxCard: View {
    let box: MealBox
    let onToggleAvailability: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Box Image with Edit/Delete buttons
            ZStack(alignment: .topTrailing) {
                if let imageData = box.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                }
                
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                            .padding(6)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                            .padding(6)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                }
                .padding(8)
            }
            
            // Box Info
            VStack(alignment: .leading, spacing: 8) {
                Text(box.name)
                    .font(.custom("Lexend-SemiBold", size: 16))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(box.description)
                    .font(.custom("Lexend-Regular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                HStack {
                    Text("₸\(Int(box.price))")
                        .font(.custom("Lexend-Bold", size: 16))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    AvailabilityBadge(isAvailable: box.isAvailable)
                }
            }
            
            // Action Button
            Button(action: onToggleAvailability) {
                Text(box.isAvailable ? "Mark Unavailable" : "Mark Available")
                    .font(.custom("Lexend-Medium", size: 12))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(box.isAvailable ? Color.red : Color.green)
                    .cornerRadius(6)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .alert("Delete Box", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this meal box? This action cannot be undone.")
        }
    }
}

struct AvailabilityBadge: View {
    let isAvailable: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isAvailable ? Color.green : Color.red)
                .frame(width: 6, height: 6)
            
            Text(isAvailable ? "Available" : "Unavailable")
                .font(.custom("Lexend-Medium", size: 10))
                .foregroundColor(isAvailable ? .green : .red)
        }
    }
}

struct AddBoxView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var description = ""
    @State private var price = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var showingImageEditor = false
    
    let onAdd: (MealBox) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Add New Meal Box")
                        .font(.custom("Lexend-SemiBold", size: 24))
                        .foregroundColor(.black)
                    
                    // Photo Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Photo")
                            .font(.custom("Lexend-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        PhotoPickerView(
                            imageData: $imageData,
                            onEditPhoto: {
                                showingImageEditor = true
                            }
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("Enter box name", text: $name)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("Enter description", text: $description, axis: .vertical)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Price (₸)")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("0", text: $price)
                                .font(.custom("Lexend-Regular", size: 16))
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        if let priceValue = Double(price), !name.isEmpty, !description.isEmpty {
                            let newBox = MealBox(
                                name: name,
                                description: description,
                                price: priceValue,
                                isAvailable: true,
                                imageData: imageData
                            )
                            onAdd(newBox)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Add Box")
                            .font(.custom("Lexend-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background((!name.isEmpty && !description.isEmpty && !price.isEmpty) ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(name.isEmpty || description.isEmpty || price.isEmpty)
                }
                .padding(20)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showingImageEditor) {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    ImageEditorView(image: uiImage) { editedImage in
                        if let editedData = editedImage.jpegData(compressionQuality: 0.8) {
                            self.imageData = editedData
                        }
                    }
                }
            }
        }
    }
}

struct EditBoxView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var description: String
    @State private var price: String
    @State private var isAvailable: Bool
    @State private var imageData: Data?
    @State private var showingImageEditor = false
    
    let box: MealBox
    let onUpdate: (MealBox) -> Void
    
    init(box: MealBox, onUpdate: @escaping (MealBox) -> Void) {
        self.box = box
        self.onUpdate = onUpdate
        self._name = State(initialValue: box.name)
        self._description = State(initialValue: box.description)
        self._price = State(initialValue: String(Int(box.price)))
        self._isAvailable = State(initialValue: box.isAvailable)
        self._imageData = State(initialValue: box.imageData)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Edit Meal Box")
                        .font(.custom("Lexend-SemiBold", size: 24))
                        .foregroundColor(.black)
                    
                    // Photo Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Photo")
                            .font(.custom("Lexend-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        PhotoPickerView(
                            imageData: $imageData,
                            onEditPhoto: {
                                showingImageEditor = true
                            }
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("Enter box name", text: $name)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("Enter description", text: $description, axis: .vertical)
                                .font(.custom("Lexend-Regular", size: 16))
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Price (₸)")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            TextField("0", text: $price)
                                .font(.custom("Lexend-Regular", size: 16))
                                .keyboardType(.numberPad)
                                .padding(12)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("Available")
                                .font(.custom("Lexend-Medium", size: 14))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isAvailable)
                        }
                    }
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        if let priceValue = Double(price), !name.isEmpty, !description.isEmpty {
                            let updatedBox = MealBox(
                                id: box.id,
                                name: name,
                                description: description,
                                price: priceValue,
                                isAvailable: isAvailable,
                                imageData: imageData
                            )
                            onUpdate(updatedBox)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Update Box")
                            .font(.custom("Lexend-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background((!name.isEmpty && !description.isEmpty && !price.isEmpty) ? Color.blue : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(name.isEmpty || description.isEmpty || price.isEmpty)
                }
                .padding(20)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showingImageEditor) {
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    ImageEditorView(image: uiImage) { editedImage in
                        if let editedData = editedImage.jpegData(compressionQuality: 0.8) {
                            self.imageData = editedData
                        }
                    }
                }
            }
        }
    }
}

struct PhotoPickerView: View {
    @Binding var imageData: Data?
    @State private var selectedPhoto: PhotosPickerItem?
    let onEditPhoto: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                // Display selected image
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                    
                    HStack(spacing: 8) {
                        Button(action: onEditPhoto) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }
                        
                        Button(action: {
                            self.imageData = nil
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(8)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                        }
                    }
                    .padding(8)
                }
            } else {
                // Photo picker placeholder
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                
                                Text("Add Photo")
                                    .font(.custom("Lexend-Medium", size: 14))
                                    .foregroundColor(.gray)
                            }
                        )
                }
            }
        }
        .onChange(of: selectedPhoto) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}

struct ImageEditorView: View {
    let image: UIImage
    let onSave: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var scale: CGFloat = 1.0
    @State private var brightness: Double = 0.0
    @State private var contrast: Double = 1.0
    @State private var saturation: Double = 1.0
    @State private var cropRect: CGRect = .zero
    @State private var showingCropMode = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Image Preview
                ZStack {
                    Color.black.opacity(0.1)
                    
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .brightness(brightness)
                        .contrast(contrast)
                        .saturation(saturation)
                        .frame(maxHeight: 300)
                        .clipped()
                        .cornerRadius(12)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(0.5, min(3.0, value))
                                }
                        )
                }
                .frame(height: 300)
                
                // Editing Controls
                VStack(spacing: 20) {
                    // Resize Control
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Size")
                                .font(.custom("Lexend-Medium", size: 14))
                            Spacer()
                            Text("\(Int(scale * 100))%")
                                .font(.custom("Lexend-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Slider(value: $scale, in: 0.5...3.0, step: 0.1)
                            .accentColor(.blue)
                    }
                    
                    // Brightness Control
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Brightness")
                                .font(.custom("Lexend-Medium", size: 14))
                            Spacer()
                            Text("\(Int(brightness * 100))")
                                .font(.custom("Lexend-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Slider(value: $brightness, in: -1.0...1.0, step: 0.05)
                            .accentColor(.blue)
                    }
                    
                    // Contrast Control
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Contrast")
                                .font(.custom("Lexend-Medium", size: 14))
                            Spacer()
                            Text("\(Int(contrast * 100))%")
                                .font(.custom("Lexend-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Slider(value: $contrast, in: 0.0...2.0, step: 0.05)
                            .accentColor(.blue)
                    }
                    
                    // Saturation Control
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Saturation")
                                .font(.custom("Lexend-Medium", size: 14))
                            Spacer()
                            Text("\(Int(saturation * 100))%")
                                .font(.custom("Lexend-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Slider(value: $saturation, in: 0.0...2.0, step: 0.05)
                            .accentColor(.blue)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button("Reset") {
                        scale = 1.0
                        brightness = 0.0
                        contrast = 1.0
                        saturation = 1.0
                    }
                    .font(.custom("Lexend-Medium", size: 16))
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    
                    Button("Save") {
                        let editedImage = applyFilters(to: image)
                        onSave(editedImage)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.custom("Lexend-Medium", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)
            .navigationTitle("Edit Photo")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func applyFilters(to image: UIImage) -> UIImage {
        // Create a CIImage from UIImage
        guard let ciImage = CIImage(image: image) else { return image }
        
        // Apply filters
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(brightness, forKey: kCIInputBrightnessKey)
        filter.setValue(contrast, forKey: kCIInputContrastKey)
        filter.setValue(saturation, forKey: kCIInputSaturationKey)
        
        guard let outputImage = filter.outputImage else { return image }
        
        // Convert back to UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }
        
        let filteredImage = UIImage(cgImage: cgImage)
        
        // Apply scale by resizing
        let targetSize = CGSize(
            width: filteredImage.size.width * scale,
            height: filteredImage.size.height * scale
        )
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        filteredImage.draw(in: CGRect(origin: .zero, size: targetSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? filteredImage
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

struct BoxesHeader: View {
    var body: some View {
        HStack {
            Text("Meal&Deal Partner")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("Boxes")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .background(Color.white)
    }
}

// MARK: - Models

struct MealBox: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    var isAvailable: Bool
    var imageData: Data?
    
    init(name: String, description: String, price: Double, isAvailable: Bool, imageData: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.price = price
        self.isAvailable = isAvailable
        self.imageData = imageData
    }
    
    init(id: UUID, name: String, description: String, price: Double, isAvailable: Bool, imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.isAvailable = isAvailable
        self.imageData = imageData
    }
}

// Sample Data - Only 2 examples with prices in tenge
let sampleBoxes: [MealBox] = [
    MealBox(
        name: "Premium Box",
        description: "Grilled chicken, quinoa, roasted vegetables, and house sauce",
        price: 4500,
        isAvailable: true
    ),
    MealBox(
        name: "Healthy Box",
        description: "Fresh salmon, brown rice, steamed broccoli, and lemon dressing",
        price: 3500,
        isAvailable: true
    )
]

#Preview {
    BoxesView()
}
