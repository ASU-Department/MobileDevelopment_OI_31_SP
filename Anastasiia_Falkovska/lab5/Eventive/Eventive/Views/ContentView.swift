import SwiftUI
import SwiftData

@available(iOS 17, *)
struct ContentView: View {

    @State private var searchText = ""

    @StateObject private var viewModel: EventsViewModel

    init() {
        let container = try! ModelContainer(for: Event.self)
        let context = ModelContext(container)

        let store = EventsStoreActor(context: context)
        let repository = TicketmasterEventsRepository(store: store)

        _viewModel = StateObject(
            wrappedValue: EventsViewModel(repository: repository)
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Text("🎫 Eventive")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack {
                    TextField("Пошук за місцем / ім'ям", text: $searchText)
                        .textFieldStyle(.roundedBorder)

                    Button("Шукати") {
                        viewModel.search(keyword: searchText)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.yellow)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                EventsListView(viewModel: viewModel)

                Spacer()
            }
            .padding()
        }
    }
}
