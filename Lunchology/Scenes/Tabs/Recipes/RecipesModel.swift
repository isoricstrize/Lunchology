//
//  RecipesModel.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  Class that controls recipes data.

import Foundation
import SwiftData

enum RecipesLayoutType {
    case grid
    case list
}

enum RecipesSortType: String, CaseIterable {
    case dateAdded = "Sort by DateAdded"
    case name = "Sort by Name"
}

public class RecipesModel: ObservableObject {
    public static let shared = RecipesModel()
    
    // Recipes data
    @Published var recipes = [Recipe]()
    // Current layout type
    @Published var layoutType: RecipesLayoutType
    // Triggers sheet with EditRecipeView
    @Published var editRecipeViewOn = false
    // True if EditRecipeView is opened with New Recipe type (adding new recipe)
    @Published var isNewRecipeMode = false
    // Triggers delete recipes mode
    @Published var isDeletingMode = false
    
    var modelContext: ModelContext?
    // Current editing(or new) recipe
    var editingRecipe = Recipe.getDefaultRecipe()
    // Default sort type
    var sortDescriptor = SortDescriptor(\Recipe.dateAdded)
    
    // Change recipe sort type
    // no published need, forcing update with fetchData
    var sortType = RecipesSortType.dateAdded {
        didSet {
            switch sortType {
            case .dateAdded:
                self.sortDescriptor = SortDescriptor(\Recipe.dateAdded)
            case .name:
                self.sortDescriptor = SortDescriptor(\Recipe.name)
            }
            // Update Grid/List view
            fetchData()
        }
    }
    
    
    init() {
        self.layoutType = .grid
    }
    
    // Fetches all recipe data from DB
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<Recipe>(sortBy: [sortDescriptor])
            recipes = try modelContext!.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    // Deletes recipe in DB
    func deleteRecipe(_ recipe: Recipe) {
        modelContext!.delete(recipe)
        fetchData()
    }
    
    // Set new values added in editingView
    func updateEditingRecipe(name: String, ingredients: [GroceryItem], instructions: String, type: RecipeType, servings: Int) {
        self.editingRecipe.name = name
        self.editingRecipe.ingredients = ingredients
        self.editingRecipe.instructions = instructions
        self.editingRecipe.type = type
        self.editingRecipe.servings = servings
        
        print("new recipe: \(isNewRecipeMode)")
                
        if (isNewRecipeMode) {
            modelContext!.insert(editingRecipe)
            fetchData()
        }
    }
    
    // Called on adding new recipe or editing exiting
    func editRecipeViewStarted(_ recipe: Recipe, isNewRecipe: Bool) {
        self.editingRecipe = recipe
        self.isNewRecipeMode = isNewRecipe
        self.editRecipeViewOn = true
    }
}


// Used for checking if string is empty or contains only whitespaces
extension String {
    func isEmptyOrWhitespace() -> Bool {
        if (self.isEmpty) {
            return true
        }
        if (self.trimmingCharacters(in: .whitespaces).isEmpty){
            return true
        }
        return false
    }
}
