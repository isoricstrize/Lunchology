//
//  GroceriesModel.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 11.04.2024..
//
//   Class that controls groceries data

import Foundation
import SwiftUI

enum GroceriesSortType: String, CaseIterable {
    case lunch = "Sort by Lunch"
    case name = "Sort by Name"
}

public class GroceriesModel: ObservableObject {
    public static let shared = GroceriesModel()
    @ObservedObject var plannerModel = PlannerModel.shared
    
    @Published var groceries = [GroceryItem]()
    //@Published var dateRange = ""

    // Current sort type
    var sortType: GroceriesSortType = .lunch {
        didSet {
            objectWillChange.send()
            setIngredientList()
        }
    }
    
    init() {
        /*let startDate = plannerModel.plannerDates[0]
        let endDate = plannerModel.plannerDates[plannerModel.plannerDates.count-1]
        var format = DateFormatter()
        format.dateFormat = "dd.MM."//"EE,dd.MM."
        dateRange = format.string(from: startDate) + "-" + format.string(from: endDate)*/
    }
    
    // Set list of ingredient for planned recipes from PlannerModel
    func setIngredientList() {
        groceries.removeAll()
        
        for recipe in plannerModel.plannedRecipes {
            // If recipe exists
            if (!recipe.name.isEmpty) {
                // Append ingredients for this recipe
                for ingredient in recipe.ingredients {
                    // Set recipe name for ingredient tag
                    ingredient.tag = recipe.name
                }
                groceries.append(contentsOf: recipe.ingredients)
            }
        }
        // Sort created groceries array
        groceries.sort(by: {
            switch sortType {
            case .lunch:
                return $0.tag < $1.tag
            case .name:
                return $0.name < $1.name
            }
        })
    }
    
    // Push groceries list to server. Add in GroceryList type for using in GroceryPlanner app.
    func pushToServer() async -> String {
        if (groceries.isEmpty) {
            return "There are no items in shopping list for upload."
        }
        
        let serverUrlString = "https://prototip.online:8080/"
        let groceryList = [GroceryList(name: "Lunches", date: .now, groceryItems: groceries)]
        
        guard let encoded = try?JSONEncoder().encode(groceryList) else {
            return "Failed to encode"
        }
        
        let url = URL(string: serverUrlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedData = try JSONDecoder().decode([GroceryList].self, from: data)
                        
            if (decodedData[0].id == groceryList[0].id) {
                return ""
            }
            
        } catch {
            return error.localizedDescription
        }
        
        return "An unexpected error occurred while uploading to the server"
    }
    
    
}
