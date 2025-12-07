import SwiftUI

struct PictureDetailView: View {

    let apod: APODResponse

    @State private var textSize: Double = 16
    @State private var showSafari = false

    private let settings = SettingsService()

    var firstSentence: String {
        apod.explanation.split(separator: ".").first.map { "\($0)." } ?? apod.explanation
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text(apod.title)
                    .font(.title2.bold())
                    .padding(.top, 16)

                AsyncImage(url: URL(string: apod.url)) { img in
                    img.resizable()
                        .scaledToFit()
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    ProgressView()
                }

                VStack(spacing: 4) {
                    Text("Adjust text size")
                        .font(.headline)

                    Slider(value: $textSize, in: 12...30, step: 1)
                        .padding(.horizontal, 30)
                }

                Text(firstSentence + "..")
                    .font(.system(size: textSize))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                Button("Open NASA Page") {
                    showSafari = true
                }
                .font(.title3.bold())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .sheet(isPresented: $showSafari) {
                    SafariView(url: URL(string: "https://apod.nasa.gov/apod/astropix.html")!)
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            textSize = settings.loadTextSize()
        }
        .onChange(of: textSize) { newValue in
            settings.saveTextSize(newValue)
        }
    }
}

