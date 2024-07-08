//
//  NewStorageContainer.swift
//  SwiftBites
//

import Foundation
import SwiftData
import SwiftUI

class NewStorageContainer {
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema([Category.self, Ingredient.self, RecipeIngredient.self, Recipe.self])
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        if isEmpty(context: container.mainContext) {
            loadSampleData(context: container.mainContext)
        }
        return container
    }
    
    private static func isEmpty(context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<Category>()
        do {
            let existingCategories = try context.fetch(descriptor)
            return existingCategories.isEmpty
        } catch {
            return false
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
//            ingredients: [],
            instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
            imageData: UIImage(named: "margherita")?.pngData()
        )
        
        margherita.ingredients = [
            RecipeIngredient(ingredient: pizzaDough, quantity: "1 ball", recipe: margherita),
            RecipeIngredient(ingredient: tomatoSauce, quantity: "1/2 cup", recipe: margherita),
            RecipeIngredient(ingredient: mozzarellaCheese, quantity: "1 cup, shredded", recipe: margherita),
            RecipeIngredient(ingredient: freshBasilLeaves, quantity: "A handful", recipe: margherita),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoon2", recipe: margherita),
            RecipeIngredient(ingredient: salt, quantity: "Pinch", recipe: margherita)
        ]
        
        let spaghettiCarbonara = Recipe(
            name: "Spaghetti Carbonara",
            summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
            category: italian,
            serving: 4,
            time: 30,
//            ingredients: [],
            instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
            imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
        )
        
        spaghettiCarbonara.ingredients = [
            RecipeIngredient(ingredient: spaghetti, quantity: "400g", recipe: spaghettiCarbonara),
            RecipeIngredient(ingredient: eggs, quantity: "4", recipe: spaghettiCarbonara),
            RecipeIngredient(ingredient: parmesanCheese, quantity: "1 cup, grated", recipe: spaghettiCarbonara),
            RecipeIngredient(ingredient: pancetta, quantity: "200g, diced", recipe: spaghettiCarbonara),
            RecipeIngredient(ingredient: blackPepper, quantity: "To taste", recipe: spaghettiCarbonara),
            RecipeIngredient(ingredient: salt, quantity: "To taste", recipe: spaghettiCarbonara)
        ]
        
        let hummus = Recipe(
            name: "Classic Hummus",
            summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
            category: middleEastern,
            serving: 6,
            time: 10,
//            ingredients: [],
            instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
            imageData: UIImage(named: "hummus")?.pngData()
        )
        
        hummus.ingredients = [
            RecipeIngredient(ingredient: chickpeas, quantity: "1 can (15 oz)", recipe: hummus),
            RecipeIngredient(ingredient: tahini, quantity: "1/4 cup", recipe: hummus),
            RecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons", recipe: hummus),
            RecipeIngredient(ingredient: garlic, quantity: "1 clove, minced", recipe: hummus),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons", recipe: hummus),
            RecipeIngredient(ingredient: cumin, quantity: "1/2 teaspoon", recipe: hummus),
            RecipeIngredient(ingredient: salt, quantity: "To taste", recipe: hummus),
            RecipeIngredient(ingredient: water, quantity: "2-3 tablespoons", recipe: hummus),
            RecipeIngredient(ingredient: paprika, quantity: "For garnish", recipe: hummus),
            RecipeIngredient(ingredient: parsley, quantity: "For garnish", recipe: hummus)
        ]
        
        
        
        let falafel = Recipe(
            name: "Classic Falafel",
            summary: "A traditional Middle Eastern dish of spiced, fried chickpea balls, often served in pita bread.",
            category: middleEastern,
            serving: 4,
            time: 60,
//            ingredients: [],
            instructions: "Soak chickpeas overnight. Blend with onions, garlic, herbs, and spices. Form into balls, add baking powder, and fry until golden.",
            imageData: UIImage(named: "falafel")?.pngData()
        )
        
        falafel.ingredients = [
            RecipeIngredient(ingredient: driedChickpeas, quantity: "1 cup", recipe: falafel),
            RecipeIngredient(ingredient: onions, quantity: "1 medium, chopped", recipe: falafel),
            RecipeIngredient(ingredient: garlic, quantity: "3 cloves, minced", recipe: falafel),
            RecipeIngredient(ingredient: cilantro, quantity: "1/2 cup, chopped", recipe: falafel),
            RecipeIngredient(ingredient: parsley, quantity: "1/2 cup, chopped", recipe: falafel),
            RecipeIngredient(ingredient: cumin, quantity: "1 tsp", recipe: falafel),
            RecipeIngredient(ingredient: coriander, quantity: "1 tsp", recipe: falafel),
            RecipeIngredient(ingredient: salt, quantity: "1 tsp", recipe: falafel),
            RecipeIngredient(ingredient: bakingPowder, quantity: "1/2 tsp", recipe: falafel)
        ]
        
        let shawarma = Recipe(
            name: "Chicken Shawarma",
            summary: "A popular Middle Eastern dish featuring marinated chicken, slow-roasted to perfection.",
            category: middleEastern,
            serving: 4,
            time: 120,
//            ingredients: [],
            instructions: "Marinate chicken with yogurt, spices, garlic, lemon juice, and olive oil. Roast until cooked. Serve with pita and sauces.",
            imageData: UIImage(named: "chickenShawarma")?.pngData()
        )
        
        shawarma.ingredients = [
            RecipeIngredient(ingredient: chickenThighs, quantity: "1 kg, boneless", recipe: shawarma),
            RecipeIngredient(ingredient: yogurt, quantity: "1 cup", recipe: shawarma),
            RecipeIngredient(ingredient: garlic, quantity: "3 cloves, minced", recipe: shawarma),
            RecipeIngredient(ingredient: lemonJuice, quantity: "3 tablespoons", recipe: shawarma),
            RecipeIngredient(ingredient: cumin, quantity: "1 tsp", recipe: shawarma),
            RecipeIngredient(ingredient: coriander, quantity: "1 tsp", recipe: shawarma),
            RecipeIngredient(ingredient: cardamom, quantity: "1/2 tsp", recipe: shawarma),
            RecipeIngredient(ingredient: cinnamon, quantity: "1/2 tsp", recipe: shawarma),
            RecipeIngredient(ingredient: turmeric, quantity: "1/2 tsp", recipe: shawarma),
            RecipeIngredient(ingredient: salt, quantity: "To taste", recipe: shawarma),
            RecipeIngredient(ingredient: blackPepper, quantity: "To taste", recipe: shawarma),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons", recipe: shawarma)
        ]
        
        
//        italian.recipes = [margherita, spaghettiCarbonara]
//        middleEastern.recipes = [hummus, falafel, shawarma]
        
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


