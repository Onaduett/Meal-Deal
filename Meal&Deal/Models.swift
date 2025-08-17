//
//  Models.swift
//  Meal&Deal
//
//  Created by Daulet Yerkinov on 17.08.25.
//

import SwiftUI

struct User: Codable {
    let id: UUID
    let email: String
    let isAdmin: Bool
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case isAdmin = "is_admin"
        case createdAt = "created_at"
    }
}
