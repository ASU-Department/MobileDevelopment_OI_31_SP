import SwiftUI

struct ContentView: View {
    // Стан для завантаження (Activity Indicator)
    @State private var isLoading = false
    // Стан для навігації
    @State private var showingProfile = false
    
    // Дані для списку акцій
    let stocks = ["Apple (AAPL)", "Tesla (TSLA)", "Nvidia (NVDA)", "Google (GOOGL)"]

    var body: some View {
        NavigationStack {
            ZStack {
                // Основний список
                List {
                    Section(header: Text("Watchlist")) {
                        ForEach(stocks, id: \.self) { stock in
                            // Навігація на деталі (NavigationLink)
                            NavigationLink(destination: StockDetailView(stockName: stock)) {
                                HStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .foregroundColor(.green)
                                    Text(stock)
                                        .font(.headline)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }
                
                // Якщо йде завантаження - показуємо наш UIKit Spinner
                if isLoading {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    VStack {
                        LoadingView(isAnimating: $isLoading, style: .large) // Наш UIKit компонент
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        Text("Updating prices...")
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                }
            }
            .navigationTitle("MarketPulse 📈")
            .toolbar {
                // Кнопка оновлення
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: loadData) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                // Кнопка профілю
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                    }
                }
            }
            // Перехід на екран профілю (Modal)
            .sheet(isPresented: $showingProfile) {
                UserProfileView()
            }
        }
    }
    
    func loadData() {
        isLoading = true
        // Імітація затримки мережі
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}

// Екран деталей (Куди переходимо по кліку)
struct StockDetailView: View {
    let stockName: String
    @State private var isFollowing = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(stockName)
                .font(.largeTitle)
                .bold()
            
            Image(systemName: "chart.bar.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .foregroundColor(.blue)
            
            // Наша кнопка з минулої лаби (спрощена)
            Button(action: { isFollowing.toggle() }) {
                HStack {
                    Image(systemName: isFollowing ? "checkmark" : "plus")
                    Text(isFollowing ? "Following" : "Follow")
                }
                .padding()
                .background(isFollowing ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}

// Екран профілю (тут буде UIViewControllerRepresentable - ImagePicker)
struct UserProfileView: View {
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 150, height: 150)
                    
                    if let inputImage = inputImage {
                        Image(uiImage: inputImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                    }
                    
                    // Кнопка редагування поверх аватарки
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { showingImagePicker = true }) {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .frame(width: 150, height: 150)
                }
                .padding()
                
                Text("User Profile")
                    .font(.title)
                
                Spacer()
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            // Виклик нашого UIKit контролера
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
    }
}
