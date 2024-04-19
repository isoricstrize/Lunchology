//
//  RecipesGridView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  Recipes list displayed in grid view

import SwiftData
import SwiftUI

struct RecipesGridView: View {
    @ObservedObject var recipesModel = RecipesModel.shared
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(recipesModel.recipes) { recipe in
                    NavigationLink(value: recipe) {
                        ZStack {
                            VStack {
                                // Recipe image
                                Image(recipe.getImageName())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 130)
                                    .padding()
                                
                                VStack {
                                    // Recipe name
                                    Text(recipe.name)
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                    
                                    // Recipe type
                                    Text(recipe.type.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(.black.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                            }
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(recipesModel.isDeletingMode ? .red : .secondary.opacity(0.3))
                                    .shadow(color: .secondary.opacity(0.3), radius: 1)
                            )
                            
                            // Delete mode
                            if recipesModel.isDeletingMode {
                                Button {
                                    // TODO: LazyVGrid scroll freezes after deleting with animation
                                    //withAnimation {
                                    recipesModel.deleteRecipe(recipe)
                                    //}
                                } label: {
                                    Image(systemName: "xmark.square.fill")
                                        .font(.title)
                                        .foregroundStyle(.white, Color.red)
                                }
                                .offset(x: 70, y: -100)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationDestination(for: Recipe.self) { recipe in
                DetailRecipeView(recipesModel: recipesModel, recipe: recipe)
            }
        }
        
    }
}

#Preview {
    RecipesGridView()
}
