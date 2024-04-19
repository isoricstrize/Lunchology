//
//  RecipesControllerView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  Displays recipes in different views (grid or list). Adding and deleting recipe, sort functionality.

import SwiftData
import SwiftUI

struct RecipesControllerView: View {
    @StateObject private var recipesModel = RecipesModel.shared
    
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        RecipesModel.shared.modelContext = modelContext
        RecipesModel.shared.fetchData()
    }
        
    var body: some View {
        Group {
            switch recipesModel.layoutType {
            case .grid:
                RecipesGridView(recipesModel: recipesModel)
            case .list:
                RecipesListView(recipesModel: recipesModel)
            }
        }
        .navigationTitle("Lunches")
        .toolbar {
            // Sort
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort by", selection: $recipesModel.sortType) {
                        ForEach(RecipesSortType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                }
                
                // Grid/List
                Button {
                    switch recipesModel.layoutType {
                    case .grid:
                        recipesModel.layoutType = .list
                    case .list:
                        recipesModel.layoutType = .grid
                    }
                } label: {
                    switch recipesModel.layoutType {
                    case .grid:
                        Image(systemName: "list.bullet")
                    case .list:
                        Image(systemName: "square.grid.2x2")
                    }
                }
                
                // Add new recipe
                Button("Add new list", systemImage: "plus") {
                    print("Add new")
                    recipesModel.editRecipeViewStarted(Recipe.getDefaultRecipe(), isNewRecipe: true)
                }
            }
            
            // Delete mode
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation {
                        recipesModel.isDeletingMode.toggle()
                    }
                } label: {
                    if recipesModel.isDeletingMode {
                        Text("Done")
                    } else {
                        Image(systemName: "trash")
                    }
                }
            }
        }
        .sheet(isPresented: $recipesModel.editRecipeViewOn) {
            EditRecipeView(recipesModel: recipesModel)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        
        return RecipesControllerView(modelContext: container.mainContext)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
