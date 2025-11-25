import Foundation
import AVFoundation
import Combine

@MainActor
final class AudioPlayerManager: ObservableObject {
    @Published var currentlyPlayingId: Int? = nil
    @Published var progress: Double = 0          // 0...1
    @Published var currentTime: Double = 0       // seconds
    @Published var duration: Double = 0          // seconds

    private var player: AVPlayer?
    private var timeObserver: Any?

    func playPreview(for song: Song) {
        guard let urlString = song.previewUrl,
              let url = URL(string: urlString) else { return }

        if currentlyPlayingId == song.id {
            stop()
            return
        }

        stop() // зняти старого observer'а, якщо був

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        currentlyPlayingId = song.id

        // У деяких випадках duration приходить трохи пізніше
        duration = item.asset.duration.seconds.isFinite ? item.asset.duration.seconds : 0
        currentTime = 0
        progress = 0

        addTimeObserver()

        player?.play()
    }

    func stop() {
        if let obs = timeObserver {
            player?.removeTimeObserver(obs)
            timeObserver = nil
        }
        player?.pause()
        player = nil
        currentlyPlayingId = nil
        progress = 0
        currentTime = 0
        duration = 0
    }

    private func addTimeObserver() {
        guard let player else { return }

        // оновлюємо раз на 0.2с
        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] t in
            guard let self else { return }
            let secs = t.seconds
            self.currentTime = secs

            let dur = player.currentItem?.duration.seconds ?? 0
            self.duration = dur.isFinite ? dur : 0

            if self.duration > 0 {
                self.progress = min(max(secs / self.duration, 0), 1)
            } else {
                self.progress = 0
            }
        }
    }

    /// Перемотка по прогресу 0...1
    func seek(to progress: Double) {
        guard let player,
              duration > 0 else { return }

        let newTime = duration * progress
        let cm = CMTime(seconds: newTime, preferredTimescale: 600)
        player.seek(to: cm)
    }
}
