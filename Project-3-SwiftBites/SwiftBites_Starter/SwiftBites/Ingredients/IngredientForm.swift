import SwiftUI

struct IngredientForm: View {
    enum Mode: Hashable {
        case add
        case edit(Ingredient)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Ingredient"
        case .edit(let ingredient):
            _name = .init(initialValue: ingredient.name)
            title = "Edit \(ingredient.name)"
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var error: Error?
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .focused($isNameFocused)
            }
            if case .edit(let ingredient) = mode {
                Button(
                    role: .destructive,
                    action: {
                        delete(ingredient: ingredient)
                    },
                    label: {
                        Text("Delete Ingredient")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
            }
        }
        .onAppear {
            isNameFocused = true
        }
        .onSubmit {
            save()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(name.isEmpty)
            }
        }
    }
    
    // MARK: - Data
    
    private func delete(ingredient: Ingredient) {
        print("IngredientForm - delete()")
        
        
        do {
            print("\tAttempting to delete ingredient")
            context.delete(ingredient)
            
            print("\tAttempting to save context")
            try context.save()
            
        } 
        
        catch {
            
            print(error.localizedDescription)
        }
        
        print("\tIngredient deleted: \(ingredient.name)")
        
        print("Current RecipeIngredients: ")
        NewStorageContainer.printSampleData(context: context, printRecipeIngredientsOnly: true)
        
        dismiss()
    }
    
    private func save() {
        print("IngredientForm - save()")
        do {
            switch mode {
            case .add:
                
                print("\tAttempting to insert ingredient into context")
                
                try context.insert(Ingredient(name: name))
                
                print("\tAttempting to save context")
                
                try context.save()
                
                print("\tIngredient saved successfully")

            case .edit(let ingredient):
                
                ingredient.name = name
                
                print("\tIngredientform - editing ingredient: \(ingredient.name)")
                
                try context.save()
                
            }
            dismiss()
        } catch {
            self.error = error
        }
    }
}
