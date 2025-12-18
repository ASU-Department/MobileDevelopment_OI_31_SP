import SwiftUI

@available(iOS 17, *)
struct EventDetailView: View {

    let event: Event

    var body: some View {
        VStack(spacing: 16) {
            Text(event.name)
                .font(.title)
                .fontWeight(.bold)

            Text("City: \(event.city)")
            Text("Date: \(event.date)")

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
    }
}
