//
//  StartView.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import SwiftUI

struct StartView: View {
    let persistenceController = PersistenceController.shared
    
    init() {
        PersistenceController.prepopulateData()
    }
    
    var body: some View {
        listView
    }
    
    @ViewBuilder
    var listView: some View {
            RecipeListView(viewModel: RecipeListViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}

#Preview {
    StartView()
}
