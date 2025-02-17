//
//  RecipeListView.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel: RecipeListViewModel
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>
    @Environment(\.managedObjectContext) var moc
    @State var selectedRecipeType: RecipeTypeModel? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Type", selection: $selectedRecipeType) {
                    Text("All").tag(nil as RecipeTypeModel?)
                    ForEach(viewModel.recipeTypes, id: \.self) {
                        Text($0.type).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Filter recipes based on the selected type
                let filteredRecipes = recipes.filter { recipe in
                    guard let selectedType = selectedRecipeType else {
                        return true
                    }
                    return recipe.type == selectedType.type
                }
                
                List(filteredRecipes) { recipe in
                    NavigationLink(destination: RecipeDetailsView(moc: moc, recipe: recipe)) {
                        RecipeListViewCell(imageData: recipe.image,
                                           title: recipe.title ?? "")
                    }
                }
            }
            .toolbar {
                Button("Add") {
                    viewModel.createNewRecipe = true
                }
            }
            .sheet(isPresented: $viewModel.createNewRecipe, content: {
                AddRecipeView(isPresented: $viewModel.createNewRecipe, moc: moc)
            })
            .navigationTitle("Recipes")
        }
    }
}

#Preview {
    RecipeListView(viewModel: RecipeListViewModel())
}
