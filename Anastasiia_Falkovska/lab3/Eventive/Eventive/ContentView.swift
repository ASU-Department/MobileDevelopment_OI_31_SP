import SwiftUI
import UIKit
import MapKit

@available(iOS 17, *)
struct ContentView: View {

    @State private var searchText = ""
    @State private var didSearch = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                Text("🎫 Eventive")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                HStack {
                    TextField("Пошук за місцем / ім'ям", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        didSearch = true
                    }) {
                        Text("Шукати")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.93, green: 0.79, blue: 0.16))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                if didSearch {
                    EventsListView(keyword: searchText)
                        .id(searchText)
                } else {
                    Text(" ")
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
        }
    }
}
