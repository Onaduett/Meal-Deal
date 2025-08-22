//
//  OrdersView.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 21.08.25.
//

import SwiftUI

struct OrdersView: View {
    @State private var selectedFilter: OrderFilter = .all
    @State private var orders: [Order] = sampleOrders
    
    var filteredOrders: [Order] {
        switch selectedFilter {
        case .all:
            return orders
        case .pending:
            return orders.filter { $0.status == .pending }
        case .preparing:
            return orders.filter { $0.status == .preparing }
        case .ready:
            return orders.filter { $0.status == .ready }
        case .completed:
            return orders.filter { $0.status == .completed }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            OrdersHeader()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Title and Refresh Button
                    HStack {
                        Text("Orders")
                            .font(.custom("Lexend-SemiBold", size: 28))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Refresh action
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Filter Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(OrderFilter.allCases, id: \.self) { filter in
                                FilterTab(
                                    title: filter.rawValue,
                                    isSelected: selectedFilter == filter,
                                    count: getOrderCount(for: filter)
                                ) {
                                    selectedFilter = filter
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Orders List
                    LazyVStack(spacing: 12) {
                        ForEach(filteredOrders) { order in
                            OrderCard(order: order) {
                                updateOrderStatus(order)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(.systemGray6))
    }
    
    private func getOrderCount(for filter: OrderFilter) -> Int {
        switch filter {
        case .all:
            return orders.count
        case .pending:
            return orders.filter { $0.status == .pending }.count
        case .preparing:
            return orders.filter { $0.status == .preparing }.count
        case .ready:
            return orders.filter { $0.status == .ready }.count
        case .completed:
            return orders.filter { $0.status == .completed }.count
        }
    }
    
    private func updateOrderStatus(_ order: Order) {
        if let index = orders.firstIndex(where: { $0.id == order.id }) {
            let nextStatus = order.status.next()
            orders[index].status = nextStatus
        }
    }
}

struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.custom("Lexend-Medium", size: 14))
                
                Text("\(count)")
                    .font(.custom("Lexend-Bold", size: 12))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(isSelected ? Color.white : Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundColor(isSelected ? .white : .gray)
            .background(isSelected ? Color.blue : Color.white)
            .cornerRadius(20)
        }
    }
}

struct OrderCard: View {
    let order: Order
    let onStatusUpdate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Order Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.orderNumber)")
                        .font(.custom("Lexend-SemiBold", size: 16))
                        .foregroundColor(.black)
                    
                    Text(order.customerName)
                        .font(.custom("Lexend-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(order.total, specifier: "%.2f")")
                        .font(.custom("Lexend-Bold", size: 16))
                        .foregroundColor(.black)
                    
                    Text(order.timeAgo)
                        .font(.custom("Lexend-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            // Order Items
            VStack(alignment: .leading, spacing: 4) {
                ForEach(order.items, id: \.name) { item in
                    HStack {
                        Text("\(item.quantity)x \(item.name)")
                            .font(.custom("Lexend-Regular", size: 14))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
            
            // Status and Action
            HStack {
                StatusBadge(status: order.status)
                
                Spacer()
                
                if order.status != .completed {
                    Button(action: onStatusUpdate) {
                        Text(order.status.nextActionTitle())
                            .font(.custom("Lexend-Medium", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
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

struct StatusBadge: View {
    let status: OrderStatus
    
    var body: some View {
        Text(status.displayName())
            .font(.custom("Lexend-Medium", size: 12))
            .foregroundColor(status.textColor())
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(status.backgroundColor())
            .cornerRadius(16)
    }
}

struct OrdersHeader: View {
    var body: some View {
        HStack {
            Text("Meal&Deal Partner")
                .font(.custom("Lexend-SemiBold", size: 20))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("Orders")
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

enum OrderFilter: String, CaseIterable {
    case all = "All"
    case pending = "Pending"
    case preparing = "Preparing"
    case ready = "Ready"
    case completed = "Completed"
}

enum OrderStatus {
    case pending
    case preparing
    case ready
    case completed
    
    func displayName() -> String {
        switch self {
        case .pending: return "Pending"
        case .preparing: return "Preparing"
        case .ready: return "Ready"
        case .completed: return "Completed"
        }
    }
    
    func backgroundColor() -> Color {
        switch self {
        case .pending: return Color.orange.opacity(0.2)
        case .preparing: return Color.blue.opacity(0.2)
        case .ready: return Color.green.opacity(0.2)
        case .completed: return Color.gray.opacity(0.2)
        }
    }
    
    func textColor() -> Color {
        switch self {
        case .pending: return .orange
        case .preparing: return .blue
        case .ready: return .green
        case .completed: return .gray
        }
    }
    
    func next() -> OrderStatus {
        switch self {
        case .pending: return .preparing
        case .preparing: return .ready
        case .ready: return .completed
        case .completed: return .completed
        }
    }
    
    func nextActionTitle() -> String {
        switch self {
        case .pending: return "Start Preparing"
        case .preparing: return "Mark Ready"
        case .ready: return "Complete Order"
        case .completed: return ""
        }
    }
}

struct Order: Identifiable {
    let id = UUID()
    let orderNumber: String
    let customerName: String
    let items: [OrderItem]
    let total: Double
    let timeAgo: String
    var status: OrderStatus
}

struct OrderItem {
    let name: String
    let quantity: Int
}

// Sample Data
let sampleOrders: [Order] = [
    Order(
        orderNumber: "1234",
        customerName: "John Doe",
        items: [
            OrderItem(name: "Premium Box", quantity: 1),
            OrderItem(name: "Drink", quantity: 2)
        ],
        total: 24.99,
        timeAgo: "5 min ago",
        status: .pending
    ),
    Order(
        orderNumber: "1235",
        customerName: "Sarah Wilson",
        items: [
            OrderItem(name: "Healthy Box", quantity: 1)
        ],
        total: 18.99,
        timeAgo: "12 min ago",
        status: .preparing
    ),
    Order(
        orderNumber: "1236",
        customerName: "Mike Johnson",
        items: [
            OrderItem(name: "Family Box", quantity: 1),
            OrderItem(name: "Dessert", quantity: 1)
        ],
        total: 45.99,
        timeAgo: "20 min ago",
        status: .ready
    ),
    Order(
        orderNumber: "1237",
        customerName: "Emily Davis",
        items: [
            OrderItem(name: "Quick Lunch", quantity: 2)
        ],
        total: 32.98,
        timeAgo: "1 hour ago",
        status: .completed
    )
]

#Preview {
    OrdersView()
}
