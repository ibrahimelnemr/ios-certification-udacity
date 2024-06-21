//
//  EventCountdownApp.swift
//  EventCountdown
//

import SwiftUI

@main
struct EventCountdownApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(events: [
                Event(id: UUID(), title: "Event 1", date: Date(), textColor: Color.black),
                Event(id: UUID(), title: "Event 2", date: Date(), textColor: Color.red),
                Event(id: UUID(), title: "Event 3", date: Date(), textColor: Color.blue)
            ])
        }
    }
}
