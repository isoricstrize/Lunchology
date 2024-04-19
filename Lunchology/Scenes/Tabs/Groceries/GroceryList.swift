//
//  GroceryList.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 14.04.2024..
//

import Foundation

struct GroceryList: Codable {
    var id = UUID()
    var name: String
    var date: Date
    var groceryItems: [GroceryItem]
    
    init(id: UUID = UUID(), name: String, date: Date, groceryItems: [GroceryItem]) {
        self.id = id
        self.name = name
        self.date = date
        self.groceryItems = groceryItems
    }
}
