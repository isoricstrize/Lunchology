//
//  Recipe.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//

import Foundation
import SwiftData

enum RecipeType: String, Codable, Equatable, CaseIterable {
    case none = "Other"
    case meat = "Meat-based"
    case fishAndSeafood = "Fish & Seafood"
    case vegetarian = "Vegetarian"
}

@Model
class Recipe: Identifiable, Hashable, Equatable {
    
    var id = UUID()
    var name: String
    @Relationship(deleteRule: .cascade) var ingredients: [GroceryItem]
    var instructions: String
    var type: RecipeType
    var servings: Int
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, ingredients: [GroceryItem], instructions: String, type: RecipeType, servings: Int, dateAdded: Date) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.type = type
        self.servings = servings
        self.dateAdded = dateAdded
    }
    
    func getImageName() -> String {
        switch type {
        case .none:
            return "other"
        case .meat:
            return "meat"
        case .fishAndSeafood:
            return "fish"
        case .vegetarian:
            return "vegetarian"
        }
    }
    
    static func getDefaultRecipe() -> Recipe {
        return Recipe(name: "New Recipe", ingredients: [], instructions: "", type: .none, servings: 1, dateAdded: .now)
    }
}
