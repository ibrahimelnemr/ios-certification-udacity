//
//  EventForm.swift
//  EventCountdown
//

import SwiftUI

struct EventForm: View {
    @Binding var events: [Event]
    @State private var title = ""
    @State private var date = Date()
    @State private var textColor = Color.black
//    var mode: Mode

    var body: some View {
        
        let onSave = { (event: Event) -> Void in
            
            print("saved event\n)")
            print("current number of events: \(events.count)\n)")

            events.append(event)
        }
        
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
            .navigationBarItems(trailing: Button("Save") {
                
                let newEvent = Event(id: UUID(),
                                     title: title,
                                     date: date,
                                     textColor: textColor)
                
                onSave(newEvent)
            })
        }
    }
    

    
    
}

//#Preview {
//    EventForm(events: events)
//}
