import SwiftUI
import SwiftData
import Charts

// --- ГОЛОВНИЙ ЕКРАН ---
struct ContentView: View {
    // --- ДАНІ ---
    @Environment(\.modelContext) private var modelContext
    
    // Сортуємо за НАЗВОЮ (symbol), щоб список не скакав
    @Query(sort: \StockItem.symbol, order: .forward) private var savedStocks: [StockItem]
    
    // --- НАЛАШТУВАННЯ ---
    @AppStorage("showExactTime") private var showExactTime = false
    
    // --- СТАН ---
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingProfile = false
    @State private var showingAddAlert = false
    @State private var newTickerName = ""
    
    let defaultTickers = ["AAPL", "TSLA", "NVDA", "GOOGL"]

    var body: some View {
        NavigationStack {
            ZStack {
                // 1. СПИСОК АКЦІЙ
                List {
                    Section {
                        Toggle("Show Update Time", isOn: $showExactTime)
                    }
                    Section(header: Text("Watchlist")) {
                        if savedStocks.isEmpty && isLoading {
                            ContentUnavailableView("Loading...", systemImage: "arrow.down.circle.dotted")
                        } else if savedStocks.isEmpty {
                            Text("List is empty. Add stocks via +")
                        } else {
                            ForEach(savedStocks) { stock in
                                NavigationLink(destination: StockDetailView(stockItem: stock)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(stock.symbol).font(.headline).bold()
                                            if showExactTime {
                                                Text(stock.timestamp.formatted(date: .omitted, time: .standard))
                                                    .font(.caption).foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                        Text("$\(String(format: "%.2f", stock.price))")
                                            .foregroundColor(.green).bold()
                                            .padding(6).background(Color.green.opacity(0.1)).cornerRadius(5)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            // СВАЙП ДЛЯ ВИДАЛЕННЯ
                            .onDelete(perform: deleteItems)
                        }
                    }
                }
                .refreshable { await updateExistingStocks() }
                
                // 2. ПЛАВАЮЧА КНОПКА "ДОДАТИ" (СПРАВА ЗНИЗУ)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            newTickerName = ""
                            showingAddAlert = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title.weight(.semibold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4, x: 0, y: 4)
                        }
                        .padding()
                    }
                }
                
                // 3. ЕКРАН ЗАВАНТАЖЕННЯ (СПІНЕР)
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.2).ignoresSafeArea()
                        VStack {
                            LoadingView(isAnimating: $isLoading, style: .large)
                                .frame(width: 50, height: 50)
                                .padding().background(Color.white).cornerRadius(10)
                            Text("Updating...").foregroundColor(.white).padding(.top, 5)
                        }
                    }
                }
            }
            .navigationTitle("MarketPulse 🌐")
            .toolbar {
                //ОНОВИТИ
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { Task { await updateExistingStocks() } }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                
                //  ПРОФІЛЬ
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingProfile = true }) {
                        Image(systemName: "person.circle.fill")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingProfile) { UserProfileView() }
            .alert("Add Stock", isPresented: $showingAddAlert) {
                TextField("Symbol (e.g. MSFT)", text: $newTickerName)
                Button("Add") { Task { await addNewStock(symbol: newTickerName) } }
                Button("Cancel", role: .cancel) { }
            }
            .alert("Error", isPresented: Binding(get: { errorMessage != nil }, set: { _ in errorMessage = nil })) {
                Button("OK", role: .cancel) { }
            } message: { Text(errorMessage ?? "") }
        }
        .onAppear {
            if savedStocks.isEmpty {
                Task {
                    isLoading = true
                    for ticker in defaultTickers { await fetchStock(symbol: ticker) }
                    isLoading = false
                }
            }
        }
    }
    
    // --- ЛОГІКА ---
    func updateExistingStocks() async {
        isLoading = true
        let symbolsToUpdate = savedStocks.map { $0.symbol }
        for symbol in symbolsToUpdate { await fetchStock(symbol: symbol) }
        isLoading = false
    }
    
    func addNewStock(symbol: String) async {
        let cleanSymbol = symbol.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanSymbol.isEmpty else { return }
        // Перевірка на дублікати
        if savedStocks.contains(where: { $0.symbol == cleanSymbol }) {
            errorMessage = "Stock \(cleanSymbol) is already in your list."
            return
        }
        isLoading = true
        await fetchStock(symbol: cleanSymbol)
        isLoading = false
    }
    
    func fetchStock(symbol: String) async {
        guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?range=1d&interval=1m") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(YahooResponse.self, from: data)
            if let result = decodedResponse.chart.result.first {
                let price = result.meta.regularMarketPrice
                await MainActor.run { saveToDatabase(symbol: symbol, price: price) }
            } else { errorMessage = "Could not find stock: \(symbol)" }
        } catch {
            if isLoading { errorMessage = "Network error or invalid symbol." }
        }
    }
    
    func saveToDatabase(symbol: String, price: Double) {
        if let existingStock = savedStocks.first(where: { $0.symbol == symbol }) {
            existingStock.price = price
            // Оновлюємо час,
            existingStock.timestamp = Date()
        } else {
            modelContext.insert(StockItem(symbol: symbol, price: price))
        }
    }
    
    // Функція видалення (працює по свайпу)
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = savedStocks[index]
            modelContext.delete(item)
        }
    }
}

// --- ЕКРАН ДЕТАЛЕЙ  ---
struct ChartPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

struct StockDetailView: View {
    let stockItem: StockItem
    @State private var isFollowing = false
    @State private var chartData: [ChartPoint] = []
    @State private var isLoadingChart = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text(stockItem.symbol).font(.system(size: 40, weight: .heavy))
                Text("Current Price").font(.subheadline).foregroundColor(.gray)
                Text("$\(String(format: "%.2f", stockItem.price))").font(.system(size: 50, weight: .bold)).foregroundColor(.green)
            }
            .padding(.top)
            
            VStack(alignment: .leading) {
                Text("Past 3 Months Trend").font(.headline).padding(.horizontal)
                if isLoadingChart {
                    HStack { Spacer(); ProgressView("Loading chart data..."); Spacer() }.frame(height: 250)
                } else if chartData.isEmpty {
                    HStack { Spacer(); Text("Chart data unavailable").foregroundColor(.gray); Spacer() }.frame(height: 250)
                } else {
                    Chart(chartData) { point in
                        LineMark(x: .value("Date", point.date), y: .value("Price", point.price))
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(LinearGradient(colors: [Color.green.opacity(0.7), Color.green.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .chartXAxis { AxisMarks(values: .stride(by: .month)) }
                    .frame(height: 250).padding(.horizontal)
                }
            }

            Button(action: { isFollowing.toggle() }) {
                HStack { Image(systemName: isFollowing ? "checkmark" : "bell.fill"); Text(isFollowing ? "Notifications On" : "Notify Me") }
                .padding().frame(maxWidth: .infinity).background(isFollowing ? Color.green : Color.orange).foregroundColor(.white).cornerRadius(12)
            }
            .padding(.horizontal).padding(.top)
            Spacer()
        }
        .navigationTitle("Details").navigationBarTitleDisplayMode(.inline)
        .task { await fetchHistoricalData() }
    }
    
    func fetchHistoricalData() async {
        isLoadingChart = true
        let urlString = "https://query1.finance.yahoo.com/v8/finance/chart/\(stockItem.symbol)?range=3mo&interval=1d"
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(HistoricalYahooResponse.self, from: data)
            if let result = decodedResponse.chart.result.first, let timestamps = result.timestamp, let prices = result.indicators.quote.first?.close {
                var loadedPoints: [ChartPoint] = []
                for i in 0..<min(timestamps.count, prices.count) {
                    if let price = prices[i] {
                        let date = Date(timeIntervalSince1970: TimeInterval(timestamps[i]))
                        loadedPoints.append(ChartPoint(date: date, price: price))
                    }
                }
                await MainActor.run { self.chartData = loadedPoints; self.isLoadingChart = false }
            }
        } catch { isLoadingChart = false }
    }
}

// --- МОДЕЛІ ДЛЯ JSON  ---
struct HistoricalYahooResponse: Codable { let chart: HistoricalChartData }
struct HistoricalChartData: Codable { let result: [HistoricalStockResult] }
struct HistoricalStockResult: Codable { let timestamp: [Int]?; let indicators: HistoricalIndicators }
struct HistoricalIndicators: Codable { let quote: [HistoricalQuote] }
struct HistoricalQuote: Codable { let close: [Double?]? }

// --- ЕКРАН ПРОФІЛЮ ---
struct UserProfileView: View {
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Circle().fill(Color.gray.opacity(0.2)).frame(width: 160, height: 160)
                    if let inputImage = inputImage {
                        Image(uiImage: inputImage).resizable().scaledToFill().frame(width: 160, height: 160).clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill").font(.system(size: 80)).foregroundColor(.gray)
                    }
                    VStack { Spacer(); HStack { Spacer(); Button(action: { showingImagePicker = true }) { Image(systemName: "camera.fill").foregroundColor(.white).padding(10).background(Color.blue).clipShape(Circle()).shadow(radius: 3) } } }.frame(width: 160, height: 160)
                }
                .padding(.top, 40)
                Text("Oleksandr Kovpak").font(.title).bold().padding(.top)
                Spacer()
            }
            .navigationTitle("My Profile")
            .toolbar { Button("Done") { presentationMode.wrappedValue.dismiss() } }
            .sheet(isPresented: $showingImagePicker) { ImagePicker(image: $inputImage) }
        }
    }
}
