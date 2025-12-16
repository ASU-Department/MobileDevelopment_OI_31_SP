import SwiftUI
import SwiftData

struct HomeView: View {

    @StateObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Text("Space Explorer")
                            .font(.largeTitle.bold())
                            .padding(.top, 16)
                            .padding(.vertical, 20)

                        if viewModel.isLoading {
                            ProgressView("Loading NASA Picture...")
                                .padding()
                        }

                        if let error = viewModel.errorMessage {
                            VStack(spacing: 6) {
                                Text("❌ Error loading APOD")
                                    .foregroundColor(.red)

                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 12)
                        }

                        if let apod = viewModel.apod {
                            Text(apod.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            AsyncImage(url: URL(string: apod.url)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                ProgressView()
                            }
                            .padding()
                        }

                        Text("Rate the astronomical picture of the day")
                            .font(.headline)
                            .padding(.top, 10)

                        HStack {
                            Button {
                                viewModel.counter = max(0, viewModel.counter - 1)
                            } label: {
                                Image(systemName: "minus.circle")
                            }

                            Text("\(viewModel.counter)")
                                .frame(width: 60)

                            Button {
                                viewModel.counter = min(10, viewModel.counter + 1)
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                        .font(.system(size: 30))
                        .foregroundStyle(.tint)
                        .padding(.vertical, 20)

                        Button("Send") {
                            viewModel.sendRating()
                        }
                        .font(.title2.bold())
                        .padding(.all, 10)
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 20)

                        if let apod = viewModel.apod {
                            NavigationLink {
                                PictureDetailView(apod: apod)
                            } label: {
                                Text("Go to Picture Info →")
                                    .font(.headline)
                                    .padding(.top, 10)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }

                if viewModel.showToast {
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
                    .animation(.easeInOut(duration: 0.3), value: viewModel.showToast)
                }
            }
        }
        .task {
            await viewModel.loadAPOD()
        }
    }
}
