//
//  EventsView.swift
//  EventCountdown
//

import SwiftUI

struct EventsView: View {
    let events: [Event]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events, id: \.self) {
                    event in
                    EventRow(event: event)
                        .swipeActions {
                            Button("Delete") {
                                // delete event
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    EventsView(events: [
        Event(id: UUID(), title: "Event 1", date: Date(), textColor: Color.green),
        Event(id: UUID(), title: "Event 2", date: Date(), textColor: Color.red),
        Event(id: UUID(), title: "Event 3", date: Date(), textColor: Color.blue)
    ])
    
}
