//
//  Event.swift
//  EventCountdown
//

import SwiftUI

struct Event: Comparable, Identifiable, Hashable {
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
    
    var id: UUID
    var title: String
    var date: Date
    var textColor: Color
}
