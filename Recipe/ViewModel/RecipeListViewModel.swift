//
//  RecipeListViewModel.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import Foundation

class RecipeListViewModel: ObservableObject {
    @Published var createNewRecipe: Bool = false
    var recipeTypes: [RecipeTypeModel] = []
    
    init() {
        self.loadRecipeTypes()
    }
    
    func loadRecipeTypes() {
        guard let url = Bundle.main.url(forResource: "recipetypes", withExtension: "json") else {
                print("Failed to locate the JSON file.")
            return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let recipes = try decoder.decode(RecipeType.self, from: data)
                self.recipeTypes = recipes.recipetypes
            } catch {
                print("Failed to decode JSON: \(error)")
            }
    }
}
