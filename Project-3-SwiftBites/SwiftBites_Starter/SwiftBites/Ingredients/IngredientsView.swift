import SwiftUI
import SwiftData

struct IngredientsView: View {
    typealias Selection = (/*MockIngredient*/Ingredient) -> Void
    
    let selection: Selection?
    
    init(selection: Selection? = nil) {
        self.selection = selection
    }
    
    @Environment (\.modelContext) var context
    @Query private var ingredients: [Ingredient]
//    @Environment(\.storage) private var storage
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    
    
    var filteredIngredients: [Ingredient] {
              let ingredientsPredicate = #Predicate<Ingredient> {
                  $0.name.localizedStandardContains(query)
              }

              let descriptor = FetchDescriptor<Ingredient>(
                  predicate: query.isEmpty ? nil : ingredientsPredicate,
                  sortBy: [SortDescriptor(\Ingredient.name, order: .forward)]
              )

              do {
                  let filteredIngredients = try context.fetch(descriptor)
                  return filteredIngredients
              } catch {
                  return []
              }
    }
    
    
    // MARK: - Body
    

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Ingredients")
                .toolbar {
//                    if !storage.ingredients.isEmpty {
                    if ingredients.isEmpty {
                        NavigationLink(value: IngredientForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: IngredientForm.Mode.self) { mode in
                    IngredientForm(mode: mode)
                }
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
//        if storage.ingredients.isEmpty {
        if ingredients.isEmpty {
            empty
        } else {
            list(for: /*storage.ingredients.filter*/ ingredients.filter {
                if query.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(query)
                }
            })
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Ingredients", systemImage: "list.clipboard")
            },
            description: {
                Text("Ingredients you add will appear here.")
            },
            actions: {
                NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
    
    private var noResults: some View {
        ContentUnavailableView(
            label: {
                Text("Couldn't find \"\(query)\"")
            }
        )
        .listRowSeparator(.hidden)
    }
    
    private func list(for ingredients: [/*MockIngredient*/Ingredient]) -> some View {
        List {
            if ingredients.isEmpty {
                noResults
            } else {
                ForEach(ingredients) { ingredient in
                    row(for: ingredient)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                delete(ingredient: ingredient)
                            }
                        }
                }
            }
        }
        .searchable(text: $query)
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for ingredient: Ingredient/*MockIngredient*/) -> some View {
        if let selection {
            Button(
                action: {
                    selection(ingredient)
                    dismiss()
                },
                label: {
                    title(for: ingredient)
                }
            )
        } else {
            NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                title(for: ingredient)
            }
        }
    }
    
    private func title(for ingredient: /*MockIngredient*/Ingredient) -> some View {
        Text(ingredient.name)
            .font(.title3)
    }
    
    // MARK: - Data
    
    private func delete(ingredient: Ingredient/*MockIngredient*/) {
//        storage.deleteIngredient(id: ingredient.id)
        context.delete(ingredient)
        print("Ingredient deleted: \(ingredient.name)")
//        print("IngredientsView - delete ingredient (needs implementation)")
    }
}
