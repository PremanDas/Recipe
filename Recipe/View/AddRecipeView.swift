//
//  AddRecipeView.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import PhotosUI
import CoreData
import SwiftUI
import UIKit

struct AddRecipeView: View {
    @StateObject var viewModel: AddRecipeViewModel
    @State var recipePicker: PhotosPickerItem?
    @State var selectedImage: UIImage?
    @State var imageData: Data?
    @State var recipeType: [RecipeTypeModel] = []
    @Environment(\.managedObjectContext) var moc
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>, moc: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: AddRecipeViewModel(moc: moc))
        _isPresented = isPresented
    }
    
    
    var body: some View {
        if #available(iOS 17.0, *) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 8) {
                        if let recipeImage = selectedImage {
                            Image(uiImage: recipeImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } else {
                            Image("recipe_placeholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                        
                        PhotosPicker("Select image",
                                     selection: $recipePicker,
                                     matching: .images)
                        .padding(.vertical)
                        
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Name *")
                                    .padding(.horizontal)
                                TextField("Recipe name",
                                          text: $viewModel.title)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal, 8)
                            }
                            
                            Spacer(minLength: 16)
                            
                            Picker("Select Type", selection: $viewModel.type) {
                                ForEach(recipeType, id: \.self) {
                                    Text($0.type).tag($0)
                                }
                            }.pickerStyle(MenuPickerStyle())
                            
                            Spacer(minLength: 16)
                            
                            Text("Ingredients *")
                                .padding(.horizontal)
                            ZStack {
                                TextEditor(text: $viewModel.ingredients)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(.black, lineWidth: 1 / 3)
                                            .opacity(0.3)
                                    )
                                    .frame(maxWidth: .infinity, minHeight: 200)
                                    .padding(.horizontal, 8)
                            }
                            
                            Spacer(minLength: 16)
                            
                            Text("Instructions *")
                                .padding(.horizontal)
                            TextEditor(text: $viewModel.steps)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1 / 3)
                                        .opacity(0.3)
                                )
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .padding(.bottom, 16)
                                .padding(.horizontal, 8)
                        }
                        
                        Spacer()
                    }
                    .toolbar(content: {
                        // Right Button
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Save") {
                                if self.viewModel.canSave() {
                                    self.viewModel.save()
                                    self.isPresented = false
                                } else {
                                    self.viewModel.showAlert = true
                                }
                            }
                        }
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Cancel") {
                                self.isPresented = false
                            }
                        }
                    })
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Error"),
                              message: Text("Please fill in all fields marked with *"))
                    }
                    .onChange(of: recipePicker) {
                        Task {
                            if let loaded = try? await recipePicker?.loadTransferable(type: Image.self) {
                                self.viewModel.convert(image: loaded) { image in
                                    self.selectedImage = image
                                    viewModel.image = selectedImage?.jpegData(compressionQuality: 0.8)
                                }
                            } else {
                                print("Failed")
                            }
                        }
                    }
                    .onAppear() {
                        self.recipeType = self.viewModel.loadRecipeTypes()
                        if let type = self.recipeType.first {
                            self.viewModel.type = type
                        }
                        UIScrollView.appearance().keyboardDismissMode = .onDrag
                    }
                }.navigationTitle("Add Recipe")
                    .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
