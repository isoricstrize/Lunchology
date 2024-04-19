//
//  PlannerData.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 09.04.2024..
//

import Foundation
import SwiftData

@Model
class PlannerData: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var recipeId: UUID
    
    init(id: UUID = UUID(), date: Date, recipeId: UUID) {
        self.id = id
        self.date = date
        self.recipeId = recipeId
    }
}
