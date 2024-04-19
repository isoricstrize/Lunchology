//
//  PlannerModel.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 08.04.2024..
//
//  Class that controls planner data

import Foundation
import SwiftData
import SwiftUI

public class PlannerModel: ObservableObject {
    public static let shared = PlannerModel()
    @ObservedObject var recipesModel = RecipesModel.shared
    
    // List of all planned recipes for current planner dates
    @Published var plannedRecipes = [Recipe]()
    // Current selected index of recipe in plannedRecipes
    @Published var selectedIndex = -1
    
    var modelContext: ModelContext?
    // Date formats
    var detailedFormat = DateFormatter()
    var dayFormat = DateFormatter()
    
    // Planner data
    var datesRecipeIds = [PlannerData]()
    // All dates for range of two weeks from today
    var plannerDates = [Date]()
    
    init() {
        self.detailedFormat.dateFormat = "EEEE, dd.MM."
        self.dayFormat.dateFormat = "dd."
    }
    
    // Fetches all planner data from DB
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<PlannerData>(sortBy: [SortDescriptor(\PlannerData.date)])
            datesRecipeIds = try modelContext!.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    // Data init for PlannerView
    func initPlannerView() {
        datesRecipeIds.removeAll()
        plannedRecipes.removeAll()

        fetchData()
        if (plannerDates.isEmpty) {
            plannerDates = getTwoWeeksFromNowDates()
        }
            
        // set recipes for plannerDates (getTwoWeeksFromNowDates)
        for plannerDate in plannerDates {
            var savedRecipe = Recipe(name: "", ingredients: [], instructions: "", type: .none, servings: 1, dateAdded: .now)
            
            // Search if in DB exists recipe saved for current planner dates
            for dateRecipeId in datesRecipeIds {
                let date = dateRecipeId.date
                let sameDay = Calendar.current.isDate(plannerDate, equalTo: date, toGranularity: .day)
                // if found recipe saved for this date
                if (sameDay){
                    savedRecipe = getRecipeById(recipeId: dateRecipeId.recipeId)
                    
                    // saved but in meantime recipe is deleted in RecipesModel
                    if (savedRecipe.name.isEmpty) {
                        modelContext!.delete(dateRecipeId)
                        savedRecipe = Recipe(name: "", ingredients: [], instructions: "", type: .none, servings: 1, dateAdded: .now)
                    }
                }
                // else -> not found planned recipe -> set empty name recipe in plannerRecipes array
            }
            plannedRecipes.append(savedRecipe)
        }
    }
    
    // Called from RecipePickerView. Changes in the recipe planner view occurred.
    func updateRecipeDate(newRecipe: Recipe) {
        // remove from db plannedData old recipe
        // set new recipe for selectedIindex in plannedRecipes
        
        // Current date for recipe change
        let currentDate = plannerDates[selectedIndex]
                
        // Remove old recipe planned for current date from DB
        for dateRecipeId in datesRecipeIds {
            let sameDay = Calendar.current.isDate(dateRecipeId.date, equalTo: currentDate, toGranularity: .day)
            if (sameDay) {
                modelContext!.delete(dateRecipeId)
            }
        }
        // Set new recipe planned for current date in DB
        modelContext!.insert(PlannerData(date: currentDate, recipeId: newRecipe.id))
        
        // Update plannedRecipes with new selected recipe
        plannedRecipes[selectedIndex] = newRecipe
    }
    
    // Return Recipe for id
    func getRecipeById(recipeId: UUID) -> Recipe {
        if let index = recipesModel.recipes.firstIndex(where: { $0.id == recipeId }) {
            return recipesModel.recipes[index]
        }
        return Recipe(name: "", ingredients: [], instructions: "", type: .none, servings: 1, dateAdded: .now)
    }
    
    // Current range two weeks. Plan your lunches two weeks in advance.
    func getTwoWeeksFromNowDates() -> [Date] {
        var dates: [Date] = []
        let now = Date()
        let twoWeeksFromNow = Calendar.current.date(byAdding: .weekOfYear, value: 2, to: now)!
        
        var currentDate = now
        while currentDate <= twoWeeksFromNow {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}
