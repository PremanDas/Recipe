//
//  Persistence.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import UIKit
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Recipe(context: viewContext)
            newItem.title = "Title \(Int.random(in: 0..<10))"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RecipeApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static func prepopulateData(){
        let viewContext = PersistenceController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let existingRecipes = (try? viewContext.fetch(fetchRequest)) ?? []
        
        if existingRecipes.isEmpty {
            let eximage1 = (UIImage(named: "Cheeseburger"))?.pngData() as Data?
            let recipe1 = Recipe(context: viewContext)
            recipe1.type = "Burger"
            recipe1.title = "Homemade Cheeseburger"
            recipe1.image = eximage1
            recipe1.ingredients = " - 500 grams beef mince \n - salt and pepper \n - 2 tbsp olive oil \n - 8 slices cheese \n - 4 buns brioche or burger buns \n - 1 brown onion finely diced \n - 4 dill pickles sliced \n - 8 tsp ketchup \n - 4 tsp American mustard"
            recipe1.steps = " 1. Place the beef mince and a generous amount of salt and pepper into a large mixing bowl.\n 2. Mix the meat in your hands until combined and separate into four equal portions.\n 3. Flatten the meat into patties, being careful not to break the edges. Rest on a board or plate until you are ready to cook. \n 4. Use a flat barbeque hotplate or large frying pan and heat the oil over high heat. \n 5. Flip the patties and cook for a further 2 minutes. Add two cheese slices to each patty and allow the cheese to melt over the top for a further two minutes. Remove from the heat and allow the patties to rest for at least 4 minutes. \n 6. To assemble, add the meat patties to the brioche buns and top with the chopped onion, sliced pickles, ketchup and mustard. Serve immediately with chips, wedges and extra pickles."
            
            let eximage2 = (UIImage(named: "CheesePizza"))?.pngData() as Data?
            let recipe2 = Recipe(context: viewContext)
            recipe2.type = "Pizza"
            recipe2.title = "Cheese Pizza"
            recipe2.image = eximage2
            recipe2.ingredients = " - 1 prepared pizza dough \n - 1/3 cup pizza sauce (80mL) \n - 1 cup shredded mozzarella cheese (115g) \n ¼ cup grated parmesan cheese (20g)"
            recipe2.steps = " 1. Position an oven rack in the lower third and preheat the oven to 475F. \n 2. On a lightly floured surface, stretch the dough into a 12-inch circle. Transfer to a non-stick baking sheet. \n 3. Spread the pizza sauce onto the dough, leaving a 1-inch border around the edge. Sprinkle with cheeses. \n 4. Bake for 12 to 14 minutes, or until the crust is browned and the cheese is bubbling and beginning to brown. Let cool for a few minutes before cutting."
            
            let eximage3 = (UIImage(named: "EggFriedRice"))?.pngData() as Data?
            let recipe3 = Recipe(context: viewContext)
            recipe3.type = "Asian"
            recipe3.title = "Egg Fried Rice"
            recipe3.image = eximage3
            recipe3.ingredients = " - Day-old rice \n - Eggs \n - Green onions \n - Salt (for extra flavor, you can add a touch of chicken bouillon or MSG as well)"
            recipe3.steps = " 1. Add oil to a large skillet and heat over medium-high heat until hot. Pour in the beaten eggs. Wait until the bottom of the eggs is just set. Lightly scramble the eggs until mostly set but some parts are still runny.\n 2. Add the rice on top of the runny egg. Use your spatula to chop the rice to separate it into small pieces, so some of the rice is coated with egg. Keep stirring and chopping the rice until the rice is well separated. Sprinkle with salt and add the green onion. Keep cooking and stir occasionally, until the rice turns slightly golden and crispy, 2 to 3 minutes. Taste the rice. Adjust seasoning by adding more salt (or a touch of chicken bouillon or MSG), if needed. You can leave the rice in the pan for a couple more minutes after turning off the stove, so the rice gets even crispier. \n 3. Transfer everything to a plate and serve hot as a side dish or a light main dish."
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }

    }
    
    func deleteAllRecipes() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        do {
            let recipes = try context.fetch(fetchRequest)
                        for recipe in recipes {
                            context.delete(recipe)
                        }
                        try context.save()
                        print("All recipes deleted successfully.")
        } catch {
            print("Failed to delete all recipes: \(error.localizedDescription)")
        }
    }

}
