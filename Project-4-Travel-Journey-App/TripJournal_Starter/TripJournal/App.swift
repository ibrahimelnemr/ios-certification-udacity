import SwiftUI

@main
struct TripJournalApp: App {
    var body: some Scene {
        WindowGroup {
            #warning("Replace the mock service with a live implementation that talks with the API.")
//            RootView(service: MockJournalServic/e(delay: 0.25))
            RootView(service: UnimplementedJournalService())
        }
    }
}

#Preview {
    RootView(service: UnimplementedJournalService())
    //            RootView(service: MockJournalServic/e(delay: 0.25))
}
