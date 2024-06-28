//
//  EventRow.swift
//  EventCountdown
//

import SwiftUI

struct EventRow : View {
    let event: Event
    @Binding var events: [Event]
    @State private var currentDate = Date()

    
    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: event.date, relativeTo: currentDate)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\t\(event.title)")
                    .foregroundColor(event.textColor)
                Text("\t\(relativeDate)")
            }
            Spacer()
            NavigationLink(destination: EventForm(mode: .edit(event: event), events: $events)) {
                Text("Edit event")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            currentDate = Date()
        }
    }
}

//#Preview {
//    EventRow(event: Event(id: UUID(), title: "Test event", date: Date(), textColor: Color.black), events: [])
//}
