import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.storage, Storage())
                .modelContainer(NewStorageContainer.create())
        }
    }
}
