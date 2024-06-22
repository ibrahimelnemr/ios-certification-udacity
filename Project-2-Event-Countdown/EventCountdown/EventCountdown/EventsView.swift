//
//  EventsView.swift
//  EventCountdown
//

import SwiftUI

struct EventsView: View {
    @State var events: [Event] = [
        Event(id: UUID(), title: "Event 1", date: Date(), textColor: Color.green),
        Event(id: UUID(), title: "Event 2", date: Date(), textColor: Color.red),
        Event(id: UUID(), title: "Event 3", date: Date(), textColor: Color.blue)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(events, id: \.self) {
                    event in
                    EventRow(event: event)
                        .swipeActions {
                            Button("Delete") {
                                if let index = events.firstIndex(where: {$0.id == event.id}) {
                                    events.remove(at: index)
                                }
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EventForm(mode: .add, events: $events)
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
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
