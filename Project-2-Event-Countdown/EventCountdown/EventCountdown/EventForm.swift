//
//  EventForm.swift
//  EventCountdown
//

import SwiftUI

struct EventForm: View {
    
    @State private var title = ""
    @State private var date = Date()
    @State private var textColor = Color.black
    
    var body: some View {
        NavigationView {
                 Form {
                     Section(header: Text("event details")) {
                         TextField("title", text: $title)
                     }

                     Section(header: Text("date")) {
                         DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                             Text("select date")
                         }
                     }

                     Section(header: Text("text color")) {
                         ColorPicker("select text color", selection: $textColor)
                     }
                 }
                 .navigationTitle("Add Event")
                 .navigationBarItems(trailing: Button("save") {
                     
                     // save event
                     
                     let newEvent = Event(id: UUID(), title: title, date: date, textColor: textColor)
                     print("saved event: \(newEvent)")
                 })
             }
    }
}

#Preview {
    EventForm()
}
