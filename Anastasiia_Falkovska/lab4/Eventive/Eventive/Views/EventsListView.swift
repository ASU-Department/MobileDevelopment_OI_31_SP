import SwiftUI

@available(iOS 17, *)
struct EventsListView: View {

    @ObservedObject var viewModel: EventsViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Пошук…")

            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)

            } else {
                List(viewModel.events) { event in
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                        Text(event.city)
                        Text(event.date)
                            .font(.caption)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
