//
//  RecipesListView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  Recipes list displayed in list view

import SwiftData
import SwiftUI

struct RecipesListView: View {
    @ObservedObject var recipesModel = RecipesModel.shared
    
    var body: some View {
        List {
            ForEach(recipesModel.recipes) { recipe in
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            // Recipe Image
                            Image(recipe.getImageName())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 50)
                        }
                        .frame(maxHeight: .infinity, alignment: .leading)
                        
                        Spacer()
                        Spacer()
                        Spacer()
                        
                        VStack {
                            // Recipe name
                            Text(recipe.name)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Recipe type
                            Text(recipe.type.rawValue)
                                .font(.caption)
                                .foregroundStyle(.primary.opacity(0.5))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
   
                    }
                    
                    // Delete mode
                    if recipesModel.isDeletingMode {
                        Button {
                            recipesModel.deleteRecipe(recipe)
                        } label: {
                            Image(systemName: "xmark.square.fill")
                                .font(.title)
                                .foregroundStyle(.white, Color.red)
                        }
                        .offset(x: 155, y: -15)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .stroke(recipesModel.isDeletingMode ? .red : .secondary.opacity(0.3))
                        .shadow(color: .secondary.opacity(0.3), radius: 1)
                )

            }
        }
        .listRowSpacing(3.0)

    }
}

#Preview {
    RecipesListView()
}
