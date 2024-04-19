//
//  DetailRecipeView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 06.04.2024..
//
//  View that displays recipe details. View only, no editing.

import SwiftData
import SwiftUI

struct DetailRecipeView: View {
    @ObservedObject var recipesModel = RecipesModel.shared
    
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .center, spacing: 40) {
                    // Recipe iamge
                    Image(recipe.getImageName())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        // Recipe name
                        Text(recipe.name)
                            .font(.title)
                            .bold()
                            .foregroundStyle(.primary)
                        
                        // Recipe type
                        Text(recipe.type.rawValue)
                            .font(.callout)
                            .foregroundStyle(.primary.opacity(0.5))
                    }
                    
                }
                .padding(.vertical)

                Divider()
                
                // Recipe ingredients
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ingredients")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text("- ")
                            .fontWeight(.regular)
                        +
                        Text((ingredient.quantity < 1) ? "" : "\(ingredient.quantity) ")
                            .fontWeight(.bold)
                        +
                        Text((ingredient.unit == .none) ? "" : "\(ingredient.unit.rawValue) ")
                            .fontWeight(.bold)
                        +
                        Text("\(ingredient.name.capitalized)")
                            .fontWeight(.regular)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical)
                
                Divider()
                
                // Recipe instructions
                VStack(alignment: .leading) {
                    Text("Instructions")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 5)
                    
                    Text(recipe.instructions)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical)
                
            }
            .padding(.top)
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Open view with edit mode
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Edit", systemImage: "square.and.pencil") {
                    recipesModel.editRecipeViewStarted(recipe, isNewRecipe: false)
                }
            }
        }
    }
}

#Preview {
    DetailRecipeView(recipe: Recipe.getDefaultRecipe())
}

