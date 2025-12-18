import SwiftUI
import SwiftData
import Charts

struct ContentView: View {
    @StateObject private var viewModel: StockListViewModel
    
    // Зберігаємо сам репозиторій, щоб передавати далі
    private let repository: StockRepository
    
    @State private var showingAddAlert = false
    @State private var newTickerName = ""
    @State private var showingProfile = false
    @AppStorage("showExactTime") private var showExactTime = false
    
    init(modelContext: ModelContainer) {
        // Створюємо репозиторій тут
        let repo = StockRepository(container: modelContext)
        self.repository = repo
        _viewModel = StateObject(wrappedValue: StockListViewModel(repository: repo))
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Section { Toggle("Show Update Time", isOn: $showExactTime) }
                    
                    Section(header: Text("Stocks")) {
                        if viewModel.stocks.isEmpty && viewModel.isLoading {
                            ContentUnavailableView("Loading...", systemImage: "arrow.down.circle.dotted")
                        } else if viewModel.stocks.isEmpty {
                            Text("No data. Pull to refresh.")
                        } else {
                            ForEach(viewModel.stocks) { stock in
                                // Передаємо репозиторій у деталі
                                NavigationLink(destination: StockDetailView(stockName: stock.symbol, repository: repository)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(stock.symbol).font(.headline).bold()
                                            if showExactTime {
                                                Text("Updated: \(stock.timestamp.formatted(date: .omitted, time: .shortened))").font(.caption).foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                        Text("$\(String(format: "%.2f", stock.price))").foregroundColor(.green).bold()
                                    }
                                }
                            }
                            .onDelete(perform: viewModel.deleteItems)
                        }
                    }
                }
                .refreshable { viewModel.loadData() }
                
                Button(action: { showingAddAlert = true }) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold)).padding().background(Color.blue).foregroundColor(.white).clipShape(Circle()).shadow(radius: 4, x: 0, y: 4)
                }
                .padding(.trailing, 20).padding(.bottom, 20)
            }
            .navigationTitle("MarketPulse")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button(action: { viewModel.loadData() }) { Image(systemName: "arrow.clockwise") } }
                ToolbarItem(placement: .navigationBarTrailing) { Button(action: { showingProfile = true }) { Image(systemName: "person.circle").font(.title3) } }
            }
            .sheet(isPresented: $showingProfile) { UserProfileView() }
            .alert("Add Stock", isPresented: $showingAddAlert) {
                TextField("Symbol (e.g. NVDA)", text: $newTickerName)
                Button("Add") { viewModel.addTicker(newTickerName); newTickerName = "" }
                Button("Cancel", role: .cancel) { }
            }
            .alert("Error", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { _ in viewModel.errorMessage = nil })) { Button("OK", role: .cancel) { } } message: { Text(viewModel.errorMessage ?? "") }
            .overlay { if viewModel.isLoading { ZStack { Color.black.opacity(0.2).ignoresSafeArea(); ProgressView().padding().background(.white).cornerRadius(10) } } }
            .onAppear { if viewModel.stocks.isEmpty { viewModel.loadData() } }
        }
    }
}

// --- ЕКРАН ПРОФІЛЮ ---
struct UserProfileView: View {
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
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
                    dismiss()
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
        }
    }
}

// --- ЕКРАН ДЕТАЛЕЙ ---
struct StockDetailView: View {
    @StateObject private var viewModel: StockDetailViewModel
    
    // Тепер приймає репозиторій
    init(stockName: String, repository: StockRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: StockDetailViewModel(symbol: stockName, repository: repository))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.symbol).font(.largeTitle).bold()
            if viewModel.isLoading { ProgressView() } else {
                Text("$\(String(format: "%.2f", viewModel.currentPrice))").font(.title).foregroundColor(.green)
                if !viewModel.priceHistory.isEmpty {
                    Chart {
                        ForEach(Array(viewModel.priceHistory.enumerated()), id: \.offset) { index, price in
                            LineMark(x: .value("Day", index), y: .value("Price", price)).foregroundStyle(.green)
                        }
                    }
                    .frame(height: 250).padding()
                } else { Text("No chart data available").foregroundColor(.gray) }
            }
            Spacer()
        }
        .navigationTitle("Analysis")
        .onAppear { viewModel.loadDetails() }
    }
}
