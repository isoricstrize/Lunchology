//
//  LunchologyApp.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//

import SwiftUI
import SwiftData

@main
struct LunchologyApp: App {
    let container: ModelContainer
        
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Recipe.self, PlannerData.self)
        } catch {
            fatalError("Failed to create ModelContainer for Movie.")
        }
        // Get app database path
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
 
