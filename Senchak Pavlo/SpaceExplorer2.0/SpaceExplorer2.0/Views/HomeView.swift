import SwiftUI
import SwiftData

struct HomeView: View {

    enum Route: Hashable {
        case detail(APODResponse)
    }

    @Environment(\.modelContext) private var context
    @Query(sort: \CachedAPOD.savedAt, order: .reverse) private var cachedApods: [CachedAPOD]

    private let service = APODService()

    @State private var counter: Int = 0
    @State private var showToast: Bool = false
    @State private var isRefreshing = false

    @State private var apod: APODResponse?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Text("Space Explorer")
                            .font(.largeTitle.bold())
                            .padding(.top, 16)
                            .padding(.vertical, 20)

                        // -------------------------------------------------
                        // LOADING
                        // -------------------------------------------------
                        if isLoading {
                            ProgressView("Loading NASA Picture...")
                                .padding()
                        }

                        // -------------------------------------------------
                        // ERROR
                        // -------------------------------------------------
                        if let errorMessage {
                            VStack(spacing: 6) {
                                Text("❌ Error loading APOD")
                                    .foregroundColor(.red)

                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Button("Retry") {
                                    Task { await loadAPOD() }
                                }
                                .padding(.top, 4)
                            }
                            .padding(.bottom, 12)
                        }

                        // -------------------------------------------------
                        // CONTENT
                        // -------------------------------------------------
                        if let apod {
                            Text(apod.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            // Always show photo even if media_type == video
                            AsyncImage(url: URL(string: apod.url)) { img in
                                img.resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                ProgressView()
                            }
                            .padding()
                        }

                        // -------------------------------------------------
                        // Rating controls
                        // -------------------------------------------------
                        Text("Rate the astronomical picture of the day")
                            .font(.headline)
                            .padding(.top, 10)

                        HStack {
                            Button {
                                if counter > 0 { counter -= 1 }
                            } label: {
                                Image(systemName: "minus.circle")
                            }

                            Text("\(counter)")
                                .frame(width: 60)

                            Button {
                                if counter < 10 { counter += 1 }
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                        .font(.system(size: 30))
                        .foregroundStyle(.tint)
                        .padding(.vertical, 20)

                        Button("Send") {
                            showToast = true
                            counter = 0
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        }
                        .font(.title2.bold())
                        .padding(.all, 10)
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 20)

                        if let apod {
                            NavigationLink(value: Route.detail(apod)) {
                                Text("Go to Picture Info →")
                                    .font(.headline)
                                    .padding(.top, 10)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }
                .refreshable {
                    await loadAPOD()
                }

                // -------------------------------------------------
                // Toast
                // -------------------------------------------------
                if showToast {
                    VStack {
                        Spacer()
                        Text("✅ Rating sent successfully")
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 60)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut(duration: 0.3), value: showToast)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detail(let apod):
                    PictureDetailView(apod: apod)
                }
            }
            .onAppear {
                if apod == nil {
                    Task { await loadAPOD() }
                }
            }
        }
    }

    // -------------------------------------------------
    // LOAD APOD WITH OFFLINE FALLBACK
    // -------------------------------------------------
    private func loadAPOD() async {
        if isRefreshing { return }

        isRefreshing = true
        isLoading = true
        errorMessage = nil

        defer { isRefreshing = false }

        do {
            let result = try await service.fetchAPOD()

            await MainActor.run {
                self.apod = result

                // clear old cache
                for item in cachedApods {
                    context.delete(item)
                }

                let cached = CachedAPOD(
                    title: result.title,
                    explanation: result.explanation,
                    url: result.url,
                    mediaType: result.media_type
                )
                context.insert(cached)

                isLoading = false
            }

        } catch {
            // If task was cancelled — ignore
            if (error as? URLError)?.code == .cancelled {
                print("⚠️ Request cancelled — ignoring")
                return
            }

            // Offline fallback
            if let local = cachedApods.first {
                await MainActor.run {
                    self.apod = local.toResponse()
                    self.errorMessage = "Showing offline version"
                    self.isLoading = false
                }
            } else {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

