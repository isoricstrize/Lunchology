//
//  EditRecipeView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  View used for edit recipe details.

import SwiftData
import SwiftUI

struct EditRecipeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var recipesModel = RecipesModel.shared
    
    // Recipe data
    @State private var name = "New Recipe"
    @State private var ingredients = [GroceryItem]()
    @State private var instructions = ""
    @State private var type = RecipeType.none
    @State private var servings = 1
    
    // Ingredient data
    @State private var ingredientName = ""
    @State private var ingredientQuantity: Int?
    @State private var ingredientUnit = GroceryUnit.none
                    
    var body: some View {
        Form {
            // Recipe name
            Section("Name") {
                TextField("Lunch name", text: $name)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(Color.red, lineWidth: name.isEmptyOrWhitespace() ? 2 : 0)
                    )
            }
            
            // Recipe ingredients
            Section("Ingredients") {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("Name", text: $ingredientName)
                        
                        TextField("Qty", value: $ingredientQuantity, format: .number)
                            .keyboardType(.decimalPad)
                            .frame(width: 50)
                        
                        Picker("", selection: $ingredientUnit) {
                            ForEach(GroceryUnit.allCases, id:\.self) { unit in
                                Text("\(unit.rawValue)")
                            }
                        }
                        .labelsHidden()
                        
                        // Add ingredient in list
                        Button {
                            ingredients.append(GroceryItem(name: ingredientName, quantity: ingredientQuantity ?? 0, unit: ingredientUnit, dateAdded: recipesModel.editingRecipe.dateAdded))
                        } label: {
                            Image(systemName: "plus.rectangle.portrait.fill")
                                .font(.title)
                                .foregroundStyle(.white, Color.accentColor)
                                .contentShape(Rectangle())
                        }
                        .disabled(ingredientName.isEmptyOrWhitespace())
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, 20)
                        .padding(.trailing, -10)
                    }
                    
                    // Displays added ingredinets. Remoce functionalty
                    List {
                        ForEach(ingredients, id: \.self) { ingredient in
                            let qnt = (ingredient.quantity < 1) ? "" : String(ingredient.quantity)
                            let unit = (ingredient.unit == .none) ? "" : ingredient.unit.rawValue
                            
                            Divider()
                            HStack {
                                Button {
                                    if let index = ingredients.firstIndex(of: ingredient) {
                                        ingredients.remove(at: index)
                                    }
                                    print("delete \(ingredient.name)")
                                } label: {
                                    Image(systemName: "xmark.square.fill")
                                                .font(.title2)
                                                .foregroundStyle(.white, Color.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Text("  \(ingredient.name.capitalized) \(qnt) \(unit)")
                                    .contentShape(Rectangle())
                                    .onTapGesture {}
                            }

                        }

                    }
                }
            }
            
            // Recipe instructions
            Section("Instructions") {
                TextField("Enter instructions", text: $instructions, axis: .vertical)
            }
            
            // TODO: Servings
            /*Section("Servings") {
                Picker("Servings", selection: $servings) {
                    ForEach(1 ..< 8) { number in
                        Text("\(number) servings")
                    }
                }
            }*/
            
            // Recipe yype
            Section("Type") {
                Picker("Select lunch type", selection: $type) {
                    ForEach(RecipeType.allCases, id:\.self) { type in
                        Text("\(type.rawValue)")
                    }
                }
            }
        
            
            Section {
                HStack {
                    Button {
                        // On save button close sheet and send new recipe data to recipesModel
                        dismiss()
                        recipesModel.updateEditingRecipe(name: name, ingredients: ingredients, instructions: instructions, type: type, servings: servings)
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(name.isEmptyOrWhitespace())

                    Button {
                        dismiss()
                    } label: {
                        Text("Discard")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .listRowBackground(Color.clear)
            
        }
        // OnAppear set current editing recipe data in edit view
        .onAppear {
            let editingRecipe = recipesModel.editingRecipe
            self.name = editingRecipe.name
            self.ingredients = editingRecipe.ingredients
            self.instructions = editingRecipe.instructions
            self.type = editingRecipe.type
            self.servings = editingRecipe.servings
        }
    }
}

#Preview {
    EditRecipeView()
}
