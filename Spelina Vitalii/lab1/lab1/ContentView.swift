import SwiftUI

struct City: Identifiable {
    let id = UUID()
    let name: String
    let polLevel: Float
    var selected: Bool = false
}

func getColorByPollutionLvl(for level: Float) -> Color {
    switch level {
        case 0..<2:
            return .green
        case 2..<3:
            return .yellow
        case 3..<4:
            return .orange
        default:
            return .red
    }
}

struct ContentView: View {
    
    @State private var cities = [
        City(name: "Kyiv", polLevel: 3.1),
        City(name: "Lviv", polLevel: 2.6),
        City(name: "Chernihiv", polLevel: 2.7),
        City(name: "Vinnytsia", polLevel: 2.1),
        City(name: "Ternopil", polLevel: 3.0),
        City(name: "Warsaw", polLevel: 1.6),
        City(name: "Krakow", polLevel: 1.8),
        City(name: "London", polLevel: 2.1),
        City(name: "New York", polLevel: 2.3),
        City(name: "Los Angeles", polLevel: 1.9),
        City(name: "Tokyo", polLevel: 1.8),
        City(name: "Shanghai", polLevel: 1.6),
        City(name: "New Dehli", polLevel: 5.7),
        City(name: "Kairo", polLevel: 3.0)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($cities) { $city in
                    Toggle(isOn: $city.selected) {
                        HStack(spacing: 15) {
                            Circle()
                                .fill(getColorByPollutionLvl(for: city.polLevel))
                                .frame(width: 10, height: 10)
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.headline)
                                Text("Pollution level: \(city.polLevel, specifier: "%.1f")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Subscribe")
        }
    }
}

#Preview {
    ContentView()
}
