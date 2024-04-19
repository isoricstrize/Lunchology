//
//  PlannerView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  View that displays planner for your lunches two weeks in advance. Each date contains can one recipe (one planned lunch for that date)

import SwiftData
import SwiftUI

struct PlannerView: View {
    @StateObject private var plannerModel = PlannerModel.shared
    @ObservedObject var recipesModel = RecipesModel.shared
    
    // Current selected recipe from planned recipe lists. Triggers sheet with RecipePickerView.
    @State private var selectedRecipe: Recipe?
    // Flag that is set after first init
    @State private var isFirstTimeInit = true
    
    var modelContext: ModelContext
        
    init(modelContext: ModelContext) {
        print("plannerView init")
        self.modelContext = modelContext
        PlannerModel.shared.modelContext = modelContext
        PlannerModel.shared.initPlannerView()
        isFirstTimeInit = false
    }
        
    var body: some View {
        List {
            ForEach (plannerModel.plannerDates.indices, id: \.self) { index in
                if (!plannerModel.plannerDates.isEmpty && !plannerModel.plannedRecipes.isEmpty) {
                    let date = plannerModel.plannerDates[index]
                    let recipe = plannerModel.plannedRecipes[index]
                    
                    HStack {
                        // Left side of planner view that displays date
                        VStack {
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(width: 2, height: 15)
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Text(plannerModel.dayFormat.string(from: date))
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(width: 2, height: 15)
                        }
                        
                        // Right side of planner view that displays recipes
                        if (recipe.name.isEmpty) {
                            Text("Tap to add lunch")
                                .font(.title3)
                                .foregroundColor(.primary.opacity(0.3))
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            HStack {
                                Image(recipe.getImageName())
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipped()
                                
                                Spacer()
                                
                                Text(recipe.name)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                            }
                            .padding(.leading, 20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor.opacity(0.1))
                                    .shadow(color: .secondary.opacity(0.3), radius: 1)
                            )
                        }
                    }
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        plannerModel.selectedIndex = index
                        selectedRecipe = plannerModel.plannedRecipes[index]
                    }
                }
            }

        }
        .onAppear {
            // Called on tab change.
            if(!isFirstTimeInit) {
                plannerModel.initPlannerView()
            }
            
        }
        .navigationTitle("Plan your lunches")
        .sheet(item: $selectedRecipe) { recipe in
            RecipePickerView(selectedRecipe: recipe)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        
        return PlannerView(modelContext: container.mainContext)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
