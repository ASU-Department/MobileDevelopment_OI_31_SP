//
//  ContentView.swift
//  SpaceExplorer_Lab2
//
//  Created by Pab1m on 09.11.2025.
//

import SwiftUI
import SafariServices


struct MainView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "cloud.sun") {
                HomeView()
            }
            .badge(1)

            Tab("Explore", systemImage: "airplane") {
                ExploreView()
            }
        }
    }
}

struct HomeView: View {
    enum Route: String {
        case detail
    }

    @State private var counter: Int = 0
    @State private var showToast: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Text("Space Explorer")
                        .font(.largeTitle.bold())
                        .padding(.top, 16)

                    Spacer()
                    
                    Image("nasa")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding()

                    Text("Rate the astronomical picture of the day")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    // Rating controls
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
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                    .font(.title2.bold())
                    .padding(.all, 10)
                    .padding(.horizontal, 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 20)

                    NavigationLink(value: Route.detail) {
                        Text("Go to Picture Info →")
                            .font(.headline)
                            .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .detail:
                        PictureDetailView()
                    }
                }

                if showToast {
                    VStack {
                        Spacer()
                        Text("✅ Rating sent successfully")
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 60)
                            .shadow(radius: 10)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut(duration: 0.3), value: showToast)
                }
            }
        }
    }
}

struct PictureDetailView: View {
    @State private var textSize: Double = 16
    
    var body: some View {
        VStack {
            Text("Astronomy Picture Details")
                .font(.title2.bold())
                .padding(.top, 20)
            
            Image("nasa")
                .resizable()
                .scaledToFit()
                .frame(width: 250)
                .padding()
            
            VStack {
                Text("Adjust Text Size")
                    .font(.headline)
                Slider(value: $textSize, in: 12...30, step: 1)
                    .padding(.horizontal, 30)
            }
            .padding(.bottom, 10)
            
            Text("Ten thousand years ago, before the dawn of recorded human history, a new light would suddenly have appeared in the night sky and faded after a few weeks.")
                .font(.system(size: textSize))
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExploreView: View {
    @State private var brightness: Double = 0.5
    @State private var showSafari: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Explore Space")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)

                Spacer()

                Text("Adjust Star Brightness")
                    .font(.headline)
                    .padding(.top, 10)

                BrightnessSlider(brightness: $brightness)
                    .frame(height: 40)
                    .padding(.horizontal, 30)

                Image(systemName: "sparkles")
                    .font(.system(size: 100))
                    .foregroundColor(.yellow.opacity(brightness))
                    .padding(.top, 20)

                Button("Open NASA Website") {
                    showSafari = true
                }
                .font(.title3.bold())
                .padding(.all, 10)
                .padding(.horizontal, 40)
                .background(Color.orange)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: "https://apod.nasa.gov/apod/astropix.html")!)
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct BrightnessSlider: UIViewRepresentable {
    @Binding var brightness: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(brightness)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(brightness)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: BrightnessSlider
        init(_ parent: BrightnessSlider) {
            self.parent = parent
        }
        @objc func valueChanged(_ sender: UISlider) {
            parent.brightness = Double(sender.value)
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

#Preview {
    MainView()
}
