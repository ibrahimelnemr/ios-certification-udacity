import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(NewStorageContainer.create(deleteExistingData: false))
            // Change to deleteExistingData: false for data not to be reset after session
        }
    }
}
