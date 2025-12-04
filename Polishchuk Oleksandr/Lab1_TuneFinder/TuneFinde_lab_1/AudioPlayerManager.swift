import Foundation
import AVFoundation
import Combine

final class AudioPlayerManager: ObservableObject {
    @Published var currentlyPlayingId: Int? = nil
    @Published var progress: Double = 0          // 0...1
    @Published var currentTime: Double = 0       // seconds
    @Published var duration: Double = 0          // seconds

    private var player: AVPlayer?
    private var timeObserver: Any?

    // MARK: - Public API

    func playPreview(for song: Song) {
        // previewUrl тепер URL?
        guard let url = song.previewUrl else { return }

        // якщо вже грає цей самий трек — зупиняємо
        if currentlyPlayingId == song.id {
            stop()
            return
        }

        // зупиняємо попередній трек (і видаляємо observer)
        stop()

        let item = AVPlayerItem(url: url)
        let newPlayer = AVPlayer(playerItem: item)
        self.player = newPlayer
        self.currentlyPlayingId = song.id

        // duration може прийти трохи пізніше, але пробуємо прочитати
        let itemDuration = item.asset.duration.seconds
        self.duration = itemDuration.isFinite ? itemDuration : 0
        self.currentTime = 0
        self.progress = 0

        addTimeObserver()
        newPlayer.play()
    }

    func stop() {
        if let obs = timeObserver, let player = player {
            player.removeTimeObserver(obs)
            timeObserver = nil
        }

        player?.pause()
        player = nil

        currentlyPlayingId = nil
        progress = 0
        currentTime = 0
        duration = 0
    }

    func seek(to progress: Double) {
        guard let player = player,
              let item = player.currentItem else { return }

        let durationSeconds = item.duration.seconds
        guard durationSeconds.isFinite, durationSeconds > 0 else { return }

        let targetSeconds = durationSeconds * progress
        let time = CMTime(seconds: targetSeconds, preferredTimescale: 600)

        player.seek(to: time)
    }

    // MARK: - Private

    private func addTimeObserver() {
        guard let player = player else { return }

        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main          // оновлення завжди на main queue
        ) { [weak self] time in
            guard let self = self else { return }

            let current = time.seconds
            self.currentTime = current

            if let item = player.currentItem {
                let dur = item.duration.seconds
                if dur.isFinite, dur > 0 {
                    self.duration = dur
                    self.progress = current / dur
                } else {
                    self.duration = 0
                    self.progress = 0
                }
            }
        }
    }

    deinit {
        stop()
    }
}
