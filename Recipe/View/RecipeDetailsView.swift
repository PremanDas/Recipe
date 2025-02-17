//
//  RecipeDetailsView.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import SwiftUI
import CoreData

struct RecipeDetailsView: View {
    @StateObject var viewModel: RecipeDetailsViewModel
    @State var isEditPresented: Bool = false
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FetchRequest var recipe: FetchedResults<Recipe>
    var selectedRecipe: Recipe
    
    init(moc: NSManagedObjectContext, recipe: Recipe) {
        self._recipe = FetchRequest<Recipe>(entity: Recipe.entity(),
                                            sortDescriptors: [],
                                            predicate: NSPredicate(format: "title == %@", recipe.title ?? ""))
        self.selectedRecipe = recipe
        _viewModel = StateObject(wrappedValue: RecipeDetailsViewModel(moc: moc, recipe: recipe))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    // Display the recipe image or a placeholder
                    if let data = selectedRecipe.image,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    } else {
                        Image("recipe_placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    }
                    
                    Spacer(minLength: 16)
                    
                    // Recipe Name
                    HStack {
                        Text("Recipe Name: ")
                            .frame(alignment: .leading)
                            .padding(.horizontal)
                        Text(self.selectedRecipe.title ?? "")
                            .frame(alignment: .leading)
                    }
                    
                    Spacer(minLength: 16)
                    
                    // Recipe Type
                    HStack {
                        Text("Recipe Type: ")
                            .frame(alignment: .leading)
                            .padding(.horizontal)
                        Text(self.selectedRecipe.type ?? "")
                            .frame(alignment: .leading)
                    }
                    
                    Spacer(minLength: 16)
                    
                    // Ingredients
                    Text("Ingredients:")
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    ZStack {
                        Text(self.selectedRecipe.ingredients ?? "")
                            .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1 / 3)
                                    .opacity(0.3)
                            )
                            .padding(.horizontal, 8)
                    }
                    
                    // Instructions
                    Text("Instructions:")
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    Text(self.selectedRecipe.steps ?? "")
                            .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1 / 3)
                                    .opacity(0.3)
                            )
                            .padding(.bottom, 16)
                            .padding(.horizontal, 8)
                }
                
                Spacer(minLength: 16)
            }
            
            // Action buttons (Edit & Delete)
            HStack {
                CustomButton(title: "Edit",
                             background: .blue,
                             action: {
                    self.isEditPresented = true
                })
                
                Spacer()
                
                CustomButton(title: "Delete",
                             background: .red,
                             action: {
                    viewModel.showDeletePopup = true
                })
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(.horizontal, 16)
        }
        .navigationTitle("Recipe Details") // Set navigation title
        .sheet(isPresented: $isEditPresented, content: {
            EditRecipeView(isPresented: $isEditPresented, viewModel: EditRecipeViewModel(moc: moc,
                                                                                            recipe: selectedRecipe))
        })
        .alert(isPresented: $viewModel.showDeletePopup) {
            Alert(title: Text("Delete Recipe"),
                  message: Text("Are you sure you want to delete this recipe?"),
                  primaryButton: .destructive(Text("Yes"), action: {
                viewModel.deleteRecipe()
                dismiss()
            }),
                  secondaryButton: .cancel(Text("No"))
            )
        }

    }
}
