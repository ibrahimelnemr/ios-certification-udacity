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
            ingredients: [pizzaDough, tomatoSauce, mozzarellaCheese, freshBasilLeaves, extraVirginOliveOil, salt],
            instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
            imageData: UIImage(named: "margherita")?.pngData()
        )

        let spaghettiCarbonara = Recipe(
            name: "Spaghetti Carbonara",
            summary: "A classic Italian pasta dish made with eggs, cheese, pancetta, and pepper.",
            category: italian,
            serving: 4,
            time: 30,
            ingredients: [spaghetti, eggs, parmesanCheese, pancetta, blackPepper],
            instructions: "Cook spaghetti. Fry pancetta until crisp. Whisk eggs and Parmesan, add to pasta with pancetta, and season with black pepper.",
            imageData: UIImage(named: "spaghettiCarbonara")?.pngData()
        )

        let hummus = Recipe(
            name: "Classic Hummus",
            summary: "A creamy and flavorful Middle Eastern dip made from chickpeas, tahini, and spices.",
            category: middleEastern,
            serving: 6,
            time: 10,
            ingredients: [chickpeas, tahini, lemonJuice, garlic, extraVirginOliveOil, cumin, salt, water, paprika, parsley],
            instructions: "Blend chickpeas, tahini, lemon juice, garlic, and spices. Adjust consistency with water. Garnish with olive oil, paprika, and parsley.",
            imageData: UIImage(named: "hummus")?.pngData()
        )

        let falafel = Recipe(
            name: "Classic Falafel",
            summary: "A traditional Middle Eastern dish of spiced, fried chickpea balls, often served in pita bread.",
            category: middleEastern,
            serving: 4,
            time: 60,
            ingredients: [driedChickpeas, onions, garlic, cilantro, parsley, cumin, coriander, salt, bakingPowder],
            instructions: "Soak chickpeas overnight. Blend with onions, garlic, herbs, and spices. Form into balls, add baking powder, and fry until golden.",
            imageData: UIImage(named: "falafel")?.pngData()
        )

        let shawarma = Recipe(
            name: "Chicken Shawarma",
            summary: "A popular Middle Eastern dish featuring marinated chicken, slow-roasted to perfection.",
            category: middleEastern,
            serving: 4,
            time: 120,
            ingredients: [chickenThighs, yogurt, garlic, lemonJuice, cumin, coriander, cardamom, cinnamon, turmeric, salt, blackPepper, extraVirginOliveOil],
            instructions: "Marinate chicken with yogurt, spices, garlic, lemon juice, and olive oil. Roast until cooked. Serve with pita and sauces.",
            imageData: UIImage(named: "chickenShawarma")?.pngData()
        )

        italian.recipes = [margherita, spaghettiCarbonara]
        middleEastern.recipes = [hummus, falafel, shawarma]

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
    }

}


