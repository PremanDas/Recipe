//
//  RecipeListViewCell.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import SwiftUI

struct RecipeListViewCell: View {
    let imageData: Data?
    let title: String
    
    var body: some View {
        HStack() {
            if let imageData = imageData {
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .frame(width: 30, height: 30)
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Text("\(title)")
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    RecipeListViewCell(imageData: nil, title: "Preman")
}

