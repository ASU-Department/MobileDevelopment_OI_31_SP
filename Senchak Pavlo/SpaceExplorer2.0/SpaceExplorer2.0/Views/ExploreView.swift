import SwiftUI

struct ExploreView: View {

    @StateObject private var viewModel = ExploreViewModel()

    var body: some View {
        VStack {
            Text("Explore Space")
                .font(.largeTitle.bold())

            BrightnessSlider(brightness: $viewModel.brightness)

            Image(systemName: "sparkles")
                .font(.system(size: 100))
                .foregroundColor(.yellow.opacity(viewModel.brightness))
        }
    }
}
