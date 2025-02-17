//
//  EditRecipeViewModel.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import Foundation
import CoreData
import SwiftUI
import UIKit

class EditRecipeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var ingredients: String = ""
    @Published var type: RecipeTypeModel? = nil
    @Published var steps: String = ""
    @Published var image: Data? = nil
    @Published var showAlert: Bool = false
    private var moc: NSManagedObjectContext
    private var recipe: Recipe
    
    init(moc: NSManagedObjectContext, recipe: Recipe) {
        self.recipe = recipe
        self.moc = moc
        self.title = recipe.title ?? ""
        self.ingredients = recipe.ingredients ?? ""
        self.type?.type = recipe.type ?? ""
        self.steps = recipe.steps ?? ""
        self.image = recipe.image
    }
    
    func save() {
        guard canSave() else { return }
        recipe.title = title
        recipe.ingredients = ingredients
        recipe.steps = steps
        if let updatedImage = image {
            recipe.image = updatedImage
        }
        
        do {
            try moc.save()
        } catch {
            print("Failed to save updated recipe: \(error)")
        }
    }
    
    func canSave() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !ingredients.trimmingCharacters(in: .whitespaces).isEmpty,
              !steps.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        return true
    }
    
    func loadRecipeTypes() -> [RecipeTypeModel] {
        guard let url = Bundle.main.url(forResource: "recipetypes", withExtension: "json") else {
                print("Failed to locate the JSON file.")
                return []
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let recipes = try decoder.decode(RecipeType.self, from: data)
                return recipes.recipetypes
            } catch {
                print("Failed to decode JSON: \(error)")
                return []
            }
    }
    
    func convert(image: Image, callback: @escaping ((UIImage?) -> Void)) {
        DispatchQueue.main.async {
            let renderer = ImageRenderer(content: image)
            callback(renderer.uiImage)
        }
    }
}

