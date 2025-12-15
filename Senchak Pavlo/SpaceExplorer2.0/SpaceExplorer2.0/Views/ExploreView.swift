import SwiftUI

struct ExploreView: View {

    @State private var brightness: Double = 0.5

    var body: some View {
        NavigationStack {
            VStack {
                Text("Explore Space")
                    .font(.largeTitle.bold())
                    .padding(.top, 20)

                Spacer()

                Text("Adjust Star Brightness")
                    .font(.headline)

                BrightnessSlider(brightness: $brightness)
                    .frame(height: 40)
                    .padding(.horizontal, 40)

                Image(systemName: "sparkles")
                    .font(.system(size: 100))
                    .foregroundColor(.yellow.opacity(brightness))
                    .padding(.top, 20)

                Spacer()
            }
            .padding()
        }
    }
}
