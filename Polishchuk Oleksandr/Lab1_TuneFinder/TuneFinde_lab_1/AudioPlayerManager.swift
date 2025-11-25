import Foundation
import AVFoundation
import Combine

@MainActor
final class AudioPlayerManager: ObservableObject {
    @Published var currentlyPlayingId: Int? = nil
    private var player: AVPlayer?
    
    func playPreview(for song: Song) {
        guard let urlString = song.previewUrl, let url = URL(string: urlString) else { return }
        
        if currentlyPlayingId == song.id {
            stop()
            return
        }
        
        player = AVPlayer(url: url)
        player?.play()
        currentlyPlayingId = song.id
    }
    
    func stop() {
        player?.pause()
        player = nil
        currentlyPlayingId = nil
    }
}
