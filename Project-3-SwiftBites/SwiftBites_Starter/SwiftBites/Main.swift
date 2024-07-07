import SwiftUI
import SwiftData

/// The main view that appears when the app is launched.
struct ContentView: View {
    @Query(sort: [SortDescriptor(\Recipe.name, order: .forward)], animation: .bouncy) private var recipes: [Recipe]
    @Query private var categories: [Category]
    @Environment(\.modelContext) var context
    @State private var selectedCategory: Category?
    
    //  @Environment(\.storage) private var storage
    
    var body: some View {
        TabView {
            RecipesView()
                .tabItem {
                    Label("Recipes", systemImage: "frying.pan")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }
            
            IngredientsView()
                .tabItem {
                    Label("Ingredients", systemImage: "carrot")
                }
        }
        .onAppear {
            //      storage.load()
        }
    }
}

#Preview {
    ContentView()
}
