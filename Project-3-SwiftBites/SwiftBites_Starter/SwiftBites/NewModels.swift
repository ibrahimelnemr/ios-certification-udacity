//
//  NewModels.swift
//  SwiftBites
//

import Foundation
import SwiftData

@Model
final class Category: Identifiable, Hashable {
    
    var id = UUID()
    
    @Attribute(.unique)
    var name: String
    
    @Relationship(inverse: \Recipe.category)
    var recipes: [Recipe] = []
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
final class Ingredient: Identifiable, Hashable {
    var id = UUID()
    
    @Attribute(.unique)
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
final class RecipeIngredient : Identifiable, Hashable {
    var id = UUID()
    var ingredient: Ingredient
    var quantity: Int
    
    init(id: UUID = UUID(), ingredient: Ingredient, quantity: Int) {
        self.id = id
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
final class Recipe: Identifiable, Hashable {
    var id = UUID()
    
    @Attribute(.unique)
    var name: String
    var summary: String
    var category: Category?
    var serving: Int
    var time: Int
    var ingredients: [Ingredient]
    var instructions: String
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        name: String,
        summary: String,
        category: Category?,
        serving: Int,
        time: Int,
        ingredients: [Ingredient],
        instructions: String,
        imageData: Data?) {
            self.id = id
            self.name = name
            self.summary = summary
            self.category = category
            self.serving = serving
            self.time = time
            self.ingredients = ingredients
            self.instructions = instructions
            self.imageData = imageData
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
