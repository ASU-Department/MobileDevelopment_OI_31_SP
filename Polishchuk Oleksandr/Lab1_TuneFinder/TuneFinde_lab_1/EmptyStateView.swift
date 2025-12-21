import SwiftUI

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "music.note.list")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(message)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 40)
    }
}
