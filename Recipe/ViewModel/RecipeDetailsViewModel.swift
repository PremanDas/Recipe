//
//  RecipeDetailsViewModel.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import Foundation
import CoreData
import SwiftUI
import UIKit

class RecipeDetailsViewModel: ObservableObject {
    private var moc: NSManagedObjectContext
    @Published var recipe: Recipe?
    @Published var showDeletePopup: Bool = false
    
    init(moc: NSManagedObjectContext, recipe: Recipe) {
        self.recipe = recipe
        self.moc = moc
    }
    
    func deleteRecipe() {
        guard let recipeToDelete = recipe else { return }
        
        moc.delete(recipeToDelete)
        
        do {
            try moc.save()
            print("Recipe deleted successfully.")
        } catch {
            print("Error deleting recipe: \(error.localizedDescription)")
        }
    }
}

