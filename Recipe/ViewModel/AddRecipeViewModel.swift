//
//  AddRecipeViewModel.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import Foundation
import SwiftUI
import CoreData

class AddRecipeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var ingredients: String = ""
    @Published var steps: String = ""
    @Published var image: Data? = nil
    @Published var type: RecipeTypeModel? = nil
    @Published var showAlert: Bool = false
    
    private var moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func save() {
        guard canSave() else { return }
        // Ensure the title and other required fields are set before saving
        let newRecipe = Recipe(context: moc)
        newRecipe.title = title
        newRecipe.ingredients = ingredients
        newRecipe.steps = steps
        newRecipe.type = type?.type // Assuming you store the type name or ID
        
        if let imageData = image {
            newRecipe.image = imageData // Storing image data (as binary)
        }
        
        do {
            try moc.save()
            print("Recipe successfully saved to Core Data!")
        } catch {
            print("Failed to save recipe: \(error.localizedDescription)")
        }
    }
    
    func canSave() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
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

            // to adjust the size, you can use this (or set a frame to get precise output size)
            // renderer.scale = 0.25
            
            // for CGImage use renderer.cgImage
            callback(renderer.uiImage)
        }
    }
}
