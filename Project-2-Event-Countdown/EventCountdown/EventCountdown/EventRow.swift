//
//  EventRow.swift
//  EventCountdown
//

import SwiftUI

struct EventRow : View {
    let event: Event
    
    var body: some View {
        HStack {
            Text("\t\(event.title)")
                .foregroundColor(event.textColor)
            Text("\t\(event.date.formatted())")
        }
        
    }
}

#Preview {
    EventRow(event: Event(id: UUID(), title: "Test event", date: Date(), textColor: Color.black))
}
