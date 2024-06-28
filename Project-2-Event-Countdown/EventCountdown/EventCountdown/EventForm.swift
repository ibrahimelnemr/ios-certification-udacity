import SwiftUI

struct EventForm: View {
    var mode: FormMode
    @Binding var events: [Event]
    @State private var title = ""
    @State private var date = Date()
    @State private var textColor = Color.black
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        let onSave = { (event: Event) -> Void in
            if let index = events.firstIndex(where: { $0.id == event.id }) {
                events[index] = event
            } else {
                events.append(event)
            }
        }

        NavigationView {
            Form {
                Section(header: Text("Event details")) {
                    TextField("Title", text: $title)
                }

                Section(header: Text("Date")) {
                    DatePicker(selection: $date, in: Date()..., displayedComponents: .date) {
                        Text("Select date")
                    }
                }

                Section(header: Text("Text color")) {
                    ColorPicker("Select Text Color", selection: $textColor)
                }
            }
            .navigationTitle(mode == .add ? "Add event" : "Edit event")
            .navigationBarItems(trailing: Button("Save") {
                if title.isEmpty {
                    alertMessage = "title cannot be empty"
                    showAlert = true
                } else {
                    let newEvent = Event(
                        id: {
                            switch mode {
                            case .add:
                                return UUID()
                            case .edit(let event):
                                return event.id
                            }
                        }(),
                        title: title,
                        date: date,
                        textColor: textColor
                    )

                    onSave(newEvent)
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                switch mode {
                case .edit(let event):
                    title = event.title
                    date = event.date
                    textColor = event.textColor
                case .add:
                    break
                }
            }
        }
    }
}
