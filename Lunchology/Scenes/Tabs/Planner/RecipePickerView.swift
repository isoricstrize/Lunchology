//
//  RecipePickerView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 08.04.2024..
//
//  View that displays list of all recipes from RecipesModel. Used for selecting recipe for current selected date.

import SwiftData
import SwiftUI

struct RecipePickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var plannerModel = PlannerModel.shared
    @ObservedObject var recipesModel = RecipesModel.shared
    
    // Current selected recipe
    @State public var selectedRecipe: Recipe
    // Current selected date
    @State private var selectedDate = Date.now
    
    var body: some View {
        VStack {
            // Title
            Text("Pick lunch for \(plannerModel.detailedFormat.string(from: selectedDate))")
                .font(.title2)
                .bold()
                .padding(.top)
            
            // List of recipes
            List {
                ForEach(recipesModel.recipes) { recipe in
                    let selected = (recipe.id == selectedRecipe.id)
                    HStack(alignment: .center) {
                        Image(recipe.getImageName())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                        
                        Spacer()
                        
                        Text(recipe.name)
                            .font(.title3)
                            .bold(selected)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        if (selected) {
                            Image(systemName: "checkmark")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.accentColor)
                                .padding(.leading)
                        }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(selected ? Color.accentColor.opacity(0.1) : .white)
                            .stroke(.secondary.opacity(0.3))
                            .shadow(color: .secondary.opacity(0.3), radius: 1)
                    )
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // if tapped already selected recipe -> unselect it
                        if (selectedRecipe.id == recipe.id) {
                            selectedRecipe = Recipe(name: "", ingredients: [], instructions: "", type: .none, servings: 1, dateAdded: .now)
                        } else {
                            selectedRecipe = recipe
                        }
                        // Set new recipe for current date
                        plannerModel.updateRecipeDate(newRecipe: selectedRecipe)
                    }
                    
                }
            }
            
            Button {
                dismiss()
            } label: {
                Text("Close")
                    .padding(.horizontal, 50)
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            // Setting current selected date
            if (plannerModel.selectedIndex > -1) {
                selectedDate = plannerModel.plannerDates[plannerModel.selectedIndex]
            }
        }
    }
}

#Preview {
    RecipePickerView( selectedRecipe: Recipe.getDefaultRecipe())
}
