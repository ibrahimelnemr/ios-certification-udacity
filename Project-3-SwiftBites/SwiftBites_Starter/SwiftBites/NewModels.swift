//
//  NewModels.swift
//  SwiftBites
//

import Foundation
import SwiftData

@Model
final class Category: Identifiable, Hashable {
    
    @Attribute(.unique)
    var id = UUID()
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
    
    init(id: UUID = UUID()) {
        self.id = id
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
    
    init(id: UUID = UUID()) {
        self.id = id
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
    
    var category: Category?
    
    init(id: UUID = UUID()) {
        self.id = id
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
