//
//  GroceriesView.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 04.04.2024..
//
//  View that displays all the necessary ingredients for the planned lunches in the Planner.

import SwiftUI

struct GroceriesView: View {
    @StateObject var groceriesModel = GroceriesModel.shared
    @ObservedObject var alertModel = AlertModel.shared
    
    var body: some View {
        List {
            ForEach(groceriesModel.groceries) { groceryItem in
                VStack {
                    HStack {
                        // Circle image
                        Image(systemName: "circlebadge.fill")
                            .foregroundColor(Color.accentColor)

                        // GroceryItem name
                        Text(groceryItem.name.capitalized)
                        
                        Spacer()
                        
                        // GroceryItem quantity
                        Text((groceryItem.quantity < 1) ? "" : "\(groceryItem.quantity) ")
                            .foregroundColor(Color.secondary)
                        +
                        
                        // GroceryItem unit
                        Text((groceryItem.unit == .none) ? "" : "\(groceryItem.unit.rawValue) ")
                            .foregroundColor(Color.secondary)

                    }
                    // GroceryItem tag (Recipe name)
                    Text(groceryItem.tag)
                        .foregroundColor(Color.secondary)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 25)
                }
                .opacity(1.0)
            }
        }
        .onAppear {
            groceriesModel.setIngredientList()
        }
        .navigationTitle("Shopping list")
        .toolbar {
            /*ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Text(groceriesModel.dateRange)
                }
            }*/
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort by", selection: $groceriesModel.sortType) {
                        ForEach(GroceriesSortType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                }
                
                Button(action: {
                    alertModel.alert = AlertWindow(id: .upload,
                                                   message: "Do you really want to upload current shopping list to server?",
                                                   dismissButton: Alert.Button.default(Text("OK")) {
                        Task {
                            let errorString = await groceriesModel.pushToServer()
                            alertModel.alert = AlertWindow(id: errorString.isEmpty ? .uploadComplete : .uploadError,
                                                           message: errorString.isEmpty ? "Your lists were successfully uploaded!" : errorString)
                        }
                    })
                    
                }, label: {
                    Label("Upload to Server", systemImage: "square.and.arrow.up")
                })
            }
        }
        
        
    }
}

#Preview {
    GroceriesView()
}
