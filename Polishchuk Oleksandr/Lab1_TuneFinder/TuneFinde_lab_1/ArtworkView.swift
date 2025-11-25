import SwiftUI

struct ArtworkView: View {
    let urlString: String?
    
    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure(_):
                placeholder
            case .empty:
                placeholder
            @unknown default:
                placeholder
            }
        }
        .frame(width: 54, height: 54)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.15))
            Image(systemName: "music.note")
                .foregroundStyle(.gray)
        }
    }
}
