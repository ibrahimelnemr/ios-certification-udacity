//
//  EventRow.swift
//  EventCountdown
//

import SwiftUI

struct EventRow : View {
    let event: Event
    @State private var currentDate = Date()

    
    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: event.date, relativeTo: currentDate)
    }
    
    var body: some View {
        HStack {
            Text("\t\(event.title)")
                .foregroundColor(event.textColor)
            Spacer()
            Text("\t\(relativeDate)")
        }.padding()
            .onAppear {
                startTimer()
            }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            currentDate = Date()
        }
    }
}

#Preview {
    EventRow(event: Event(id: UUID(), title: "Test event", date: Date(), textColor: Color.black))
}
