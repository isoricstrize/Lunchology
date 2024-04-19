//
//  ContentView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject private var alertModel = AlertModel.shared
    @State private var selectedTab = "Recipes"
    
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                RecipesControllerView(modelContext: modelContext)
            }
            .tabItem {
                Label("Lunch", systemImage: "fork.knife")
            }
            .tag("Recipes")

            
            NavigationStack {
                PlannerView(modelContext: modelContext)
            }
            .tabItem {
                Label("Plan", systemImage: "calendar")
            }
            .tag("Planner")
                
            
            NavigationStack {
                GroceriesView()
            }
            .tabItem {
                Label("Shop", systemImage: "cart.fill")
            }
            .tag("Groceries")
        }
        .preferredColorScheme(.light)
    
        .alert(item: $alertModel.alert) { alert in
            if alert.hasCancelButton {
                return Alert(title: Text(alert.title),
                             message: Text(alert.message),
                             primaryButton: alert.dismissButton!,
                             secondaryButton: Alert.Button.cancel(Text("Cancel")) {})
            }
            return Alert(title: Text(alert.title), 
                         message: Text(alert.message),
                         dismissButton: alert.dismissButton)
        }
        
        
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recipe.self, configurations: config)
        
        return ContentView(modelContext: container.mainContext)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
