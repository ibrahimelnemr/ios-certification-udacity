//
//  NewStorageContainer.swift
//  SwiftBites
//

import Foundation
import SwiftData
import SwiftUI

class NewStorageContainer {
    @MainActor
    static func create(deleteExistingData: Bool = false) -> ModelContainer {
        print("NewStorageContainer - create()")
        let schema = Schema([Category.self, Ingredient.self, RecipeIngredient.self, Recipe.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        
        if (deleteExistingData) {
            deleteSampleData(context: container.mainContext)
            loadSampleData(context: container.mainContext)
        }
        
        else {
            if isEmpty(context: container.mainContext) {
                loadSampleData(context: container.mainContext)
            }
        }

        printSampleData(context: container.mainContext)
        
        
        
        return container
    }
    
    private static func isEmpty(context: ModelContext) -> Bool {
        print("NewStorageContainer - isEmpty()")
        let categoryDescriptor = FetchDescriptor<Category>()
        let ingredientDescriptor = FetchDescriptor<Ingredient>()
        let recipeDescriptor = FetchDescriptor<Recipe>()
        let recipeIngredientDescriptor = FetchDescriptor<RecipeIngredient>()
        
        do {
            let existingCategories = try context.fetch(categoryDescriptor)
            let existingIngredients = try context.fetch(ingredientDescriptor)
            let existingRecipes = try context.fetch(recipeDescriptor)
            let existingRecipeIngredients = try context.fetch(recipeIngredientDescriptor)
            return existingCategories.isEmpty && existingIngredients.isEmpty && existingRecipes.isEmpty && existingRecipeIngredients.isEmpty
        } catch {
            return false
        }
    }
    
    private static func deleteSampleData(context: ModelContext) {
        print("NewStorageContainer - deleteSampleData()")
        let categoryDescriptor = FetchDescriptor<Category>()
        let ingredientDescriptor = FetchDescriptor<Ingredient>()
        let recipeDescriptor = FetchDescriptor<Recipe>()
        let recipeIngredientDescriptor = FetchDescriptor<RecipeIngredient>()
        
        do {
            let categories = try context.fetch(categoryDescriptor)
            for category in categories {
                context.delete(category)
            }
            
            let ingredients = try context.fetch(ingredientDescriptor)
            for ingredient in ingredients {
                context.delete(ingredient)
            }
            
            let recipes = try context.fetch(recipeDescriptor)
            for recipe in recipes {
                context.delete(recipe)
            }
            
            let recipeIngredients = try context.fetch(recipeIngredientDescriptor)
            for recipeIngredient in recipeIngredients {
                context.delete(recipeIngredient)
            }
            
            try context.save()
            print("All data deleted.")
        } catch {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }

    public static func printSampleData(context: ModelContext, printAll: Bool=false, printCategoriesOnly: Bool = false, printIngredientsOnly: Bool = false, printRecipesOnly: Bool = false, printRecipeIngredientsOnly: Bool = false) {
        print("NewStorageContainer - printSampleData()")
        let categoryDescriptor = FetchDescriptor<Category>()
        let ingredientDescriptor = FetchDescriptor<Ingredient>()
        let recipeDescriptor = FetchDescriptor<Recipe>()
        let recipeIngredientDescriptor = FetchDescriptor<RecipeIngredient>()
        
        print("PRINTING SAMPLE DATA")
        
        do {
            
            if (printAll || printCategoriesOnly) {
                
                let categories = try context.fetch(categoryDescriptor)
                
                print("CATEGORIES")
                
                for category in categories {
                    print("\tCategory")
                    print("\t\t\(category.name)")
                    for recipe in category.recipes ?? [] {
                        print("\t\t\t\(recipe.name)")
                    }
                }
            }
            
            if (printAll || printIngredientsOnly) {
            
                print("INGREDIENTS")
                let ingredients = try context.fetch(ingredientDescriptor)
                for ingredient in ingredients {
                    print("\tIngredient")
                    print("\t\t\(ingredient.name)")
                }
            }
            
            
            if (printAll || printRecipesOnly) {
                let recipes = try context.fetch(recipeDescriptor)
                
                print("RECIPES")
                for recipe in recipes {
                    print("\tRecipe")
                    print("\t\t\(recipe.name)")
                    print("\t\t\tCategory: \(recipe.category?.name ?? "N/A")")
                }
            }
            
            if (printAll || printRecipeIngredientsOnly) {
                print("RECIPEINGREDIENTS")
                let recipeIngredients = try context.fetch(recipeIngredientDescriptor)
                for recipeIngredient in recipeIngredients {
                    print("\tRecipeIngredient")
                    if ((recipeIngredient.ingredient) != nil) {
                        print("\t\t\(recipeIngredient.ingredient?.name ?? "N/A")")
                    }
                    print("\t\t\(recipeIngredient.quantity)")

                }
            }

            
        } catch {
            print("NewStorageContainer printSampleData() Error printing data: \(error.localizedDescription)")
        }
    }
    
    private static func loadSampleData(context: ModelContext) {
        let pizzaDough = Ingredient(name: "Pizza Dough")
        let tomatoSauce = Ingredient(name: "Tomato Sauce")
        let mozzarellaCheese = Ingredient(name: "Mozzarella Cheese")
        let freshBasilLeaves = Ingredient(name: "Fresh Basil Leaves")
        let extraVirginOliveOil = Ingredient(name: "Extra Virgin Olive Oil")
        let salt = Ingredient(name: "Salt")
        let chickpeas = Ingredient(name: "Chickpeas")
        let tahini = Ingredient(name: "Tahini")
        let lemonJuice = Ingredient(name: "Lemon Juice")
        let garlic = Ingredient(name: "Garlic")
        let cumin = Ingredient(name: "Cumin")
        let water = Ingredient(name: "Water")
        let paprika = Ingredient(name: "Paprika")
        let parsley = Ingredient(name: "Parsley")
        let spaghetti = Ingredient(name: "Spaghetti")
        let eggs = Ingredient(name: "Eggs")
        let parmesanCheese = Ingredient(name: "Parmesan Cheese")
        let pancetta = Ingredient(name: "Pancetta")
        let blackPepper = Ingredient(name: "Black Pepper")
        let driedChickpeas = Ingredient(name: "Dried Chickpeas")
        let onions = Ingredient(name: "Onions")
        let cilantro = Ingredient(name: "Cilantro")
        let coriander = Ingredient(name: "Coriander")
        let bakingPowder = Ingredient(name: "Baking Powder")
        let chickenThighs = Ingredient(name: "Chicken Thighs")
        let yogurt = Ingredient(name: "Yogurt")
        let cardamom = Ingredient(name: "Cardamom")
        let cinnamon = Ingredient(name: "Cinnamon")
        let turmeric = Ingredient(name: "Turmeric")
        
        let italian = Category(name: "Italian")
        let middleEastern = Category(name: "Middle Eastern")
        
        let margherita = Recipe(
            name: "Classic Margherita Pizza",
            summary: "A simple yet delicious pizza with tomato, mozzarella, basil, and olive oil.",
            category: italian,
            serving: 4,
            time: 50,
            ingredients: [],
            instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
            imageData: UIImage(named: "margherita")?.pngData()
        )
        
        margherita.ingredients = [
            RecipeIngredient(ingredient: pizzaDough, quantity: "1 ball"),
            RecipeIngredient(ingredient: tomatoSauce, quantity: "1/2 cup"),
            RecipeIngredient(ingredient: mozzarellaCheese, quantity: "1 cup, shredded"),
            RecipeIngredient(ingredient: freshBasilLeaves, quantity: "A handful"),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
            RecipeIngredient(ingredient: salt, quantity: "Pinch")
        ]
        
        
        let spaghettiCarbonara = Recipe(
            name: "Spaghetti Carbonara",
            summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
            category: italian,
            serving: 4,
            time: 30,
            ingredients: [],
            instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
            imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
        )
        
        spaghettiCarbonara.ingredients = [
             RecipeIngredient(ingredient: spaghetti, quantity: "400g"),
             RecipeIngredient(ingredient: eggs, quantity: "4"),
             RecipeIngredient(ingredient: parmesanCheese, quantity: "1 cup, grated"),
             RecipeIngredient(ingredient: pancetta, quantity: "200g, diced"),
             RecipeIngredient(ingredient: blackPepper, quantity: "To taste"),
             RecipeIngredient(ingredient: salt, quantity: "To taste")
         ]
        
        let hummus = Recipe(
            name: "Classic Hummus",
            summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
            category: middleEastern,
            serving: 6,
            time: 10,
            ingredients: [],
            instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
            imageData: UIImage(named: "hummus")?.pngData()
        )
        
        hummus.ingredients = [
            RecipeIngredient(ingredient: chickpeas, quantity: "1 can (15 oz)"),
            RecipeIngredient(ingredient: tahini, quantity: "1/4 cup"),
            RecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons"),
            RecipeIngredient(ingredient: garlic, quantity: "1 clove, minced"),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
            RecipeIngredient(ingredient: cumin, quantity: "1/2 teaspoon"),
            RecipeIngredient(ingredient: salt, quantity: "To taste"),
            RecipeIngredient(ingredient: water, quantity: "2-3 tablespoons"),
            RecipeIngredient(ingredient: paprika, quantity: "For garnish"),
            RecipeIngredient(ingredient: parsley, quantity: "For garnish")
        ]
        
        let falafel = Recipe(
            name: "Classic Falafel",
            summary: "A traditional Middle Eastern dish of spiced, fried chickpea balls, often served in pita bread.",
            category: middleEastern,
            serving: 4,
            time: 60,
            ingredients: [],
            instructions: "Soak chickpeas overnight. Blend with onions, garlic, herbs, and spices. Form into balls, add baking powder, and fry until golden.",
            imageData: UIImage(named: "falafel")?.pngData()
        )
        
        falafel.ingredients = [
            RecipeIngredient(ingredient: driedChickpeas, quantity: "1 cup"),
            RecipeIngredient(ingredient: onions, quantity: "1 medium, chopped"),
            RecipeIngredient(ingredient: garlic, quantity: "3 cloves, minced"),
            RecipeIngredient(ingredient: cilantro, quantity: "1/2 cup, chopped"),
            RecipeIngredient(ingredient: parsley, quantity: "1/2 cup, chopped"),
            RecipeIngredient(ingredient: cumin, quantity: "1 tsp"),
            RecipeIngredient(ingredient: coriander, quantity: "1 tsp"),
            RecipeIngredient(ingredient: salt, quantity: "1 tsp"),
            RecipeIngredient(ingredient: bakingPowder, quantity: "1/2 tsp")
        ]

        
        let shawarma = Recipe(
            name: "Chicken Shawarma",
            summary: "A popular Middle Eastern dish featuring marinated chicken, slow-roasted to perfection.",
            category: middleEastern,
            serving: 4,
            time: 120,
            ingredients: [],
            instructions: "Marinate chicken with yogurt, spices, garlic, lemon juice, and olive oil. Roast until cooked. Serve with pita and sauces.",
            imageData: UIImage(named: "chickenShawarma")?.pngData()
        )
        
        shawarma.ingredients = [
            RecipeIngredient(ingredient: chickenThighs, quantity: "1 kg, boneless"),
            RecipeIngredient(ingredient: yogurt, quantity: "1 cup"),
            RecipeIngredient(ingredient: garlic, quantity: "3 cloves, minced"),
            RecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons"),
            RecipeIngredient(ingredient: cumin, quantity: "1 tsp"),
            RecipeIngredient(ingredient: coriander, quantity: "1 tsp"),
            RecipeIngredient(ingredient: cardamom, quantity: "1/2 tsp"),
            RecipeIngredient(ingredient: cinnamon, quantity: "1/2 tsp"),
            RecipeIngredient(ingredient: turmeric, quantity: "1/2 tsp"),
            RecipeIngredient(ingredient: salt, quantity: "To taste"),
            RecipeIngredient(ingredient: blackPepper, quantity: "To taste"),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons")
        ]
        
        
        let ingredients = [
            pizzaDough, tomatoSauce, mozzarellaCheese, freshBasilLeaves, extraVirginOliveOil, salt,
            chickpeas, tahini, lemonJuice, garlic, cumin, water, paprika, parsley, spaghetti, eggs,
            parmesanCheese, pancetta, blackPepper, driedChickpeas, onions, cilantro, coriander, bakingPowder,
            chickenThighs, yogurt, cardamom, cinnamon, turmeric
        ]
        
        let categories = [italian, middleEastern]
        let recipes = [margherita, spaghettiCarbonara, hummus, falafel, shawarma]

        for ingredient in ingredients {
            context.insert(ingredient)
        }
        
        for category in categories {
            context.insert(category)
        }
        
        for recipe in recipes {
            context.insert(recipe)
        }
        
        print("Entered all sample data into storage container")
    }
    
}


