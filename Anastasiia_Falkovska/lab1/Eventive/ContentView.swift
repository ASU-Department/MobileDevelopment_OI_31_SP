import SwiftUI
import MapKit

struct ContentView: View {
    // збереження тексту, введеного у поле пошуку
    @State private var searchText: String = ""
    
    // керування станом, чи виконано пошук
    @State private var isSearching: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // заголовок
                Text("🎫 Eventive")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // поле пошуку та кнопка
                HStack {
                    // поле для введення тексту
                    TextField("Пошук за місцем / датою / ім'ям", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // кнопка пошуку
                    Button(action: {
                        // зміна стану isSearching
                        isSearching.toggle()
                    }) {
                        Text("Шукати")
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(red: 0.93, green: 0.79, blue: 0.16))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                // передача стану в дочірній компонент через Binding
                SearchResultsView(isSearching: $isSearching)
                
                Spacer()
            }
            .padding()
        }
    }
}

// дочірній компонент для відображення результатів пошуку
struct SearchResultsView: View {
    // Binding отримує посилання на змінну isSearching із батьківського
    @Binding var isSearching: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isSearching {
                Text("Результати пошуку")
                    .font(.headline)
                
                // приклад події
                NavigationLink(destination: EventDetailView()) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Філіп К. Дік – «Чи мріють андроїди?» Читання та панельна дискусія")
                            .font(.headline)
                        Text("Львів, America House")
                            .font(.subheadline)
                        Text("17 листопада, 2025")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
            } else {
                Text("Події не існує")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

// вікно з деталями події
struct EventDetailView: View {
    // координати Львова
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Філіп К. Дік – «Чи мріють андроїди?»")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Читання та панельна дискусія про культову книгу письменника, що надихнула на створення не менш легендарного фільму 'Blade Runner'.")
                .font(.body)
            
            Text("📍 Локація: Львів, America House")
                .font(.subheadline)
            
            Text("📅 Дата: 17 листопада, 2025")
                .font(.subheadline)
            
            Text("💸 Вхід вільний")
                .font(.subheadline)

            Map(coordinateRegion: $region)
                .frame(height: 200)
                .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Деталі події")
        .navigationBarTitleDisplayMode(.inline)
    }
}
