import Foundation
import AVKit
import Combine
import SwiftUI

class VideoPlayerViewModel: NSObject, ObservableObject {
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var isMuted = false
    @Published var isFullScreen = false
    @Published var isPictureInPictureEnabled = false
    @Published var showingInSight = false
    @Published var isFullScreenPlayer = false
    @Published var playbackRate: Float = 1.0
    
    private var timeObserver: Any?
    let video: Video
    
    init(video: Video) {
        self.video = video
        super.init()
        setupPlayer()
    }
    
    private func setupPlayer() {
        let player = AVPlayer(url: video.videoURL)
        self.player = player
        
        // Add observer for duration changes
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        
        // Add observer for player item status
        player.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .initial], context: nil)
        
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            self?.currentTime = time.seconds
        }
        
        // Try to get initial duration
        if let duration = player.currentItem?.duration, duration.isValid {
            self.duration = duration.seconds
        }
    }
    
    // MARK: - Player Controls
    
    func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            // When starting playback, enter full screen and play
            withAnimation(.spring()) {
                isFullScreenPlayer = true
                showingInSight = false
                player?.play()
            }
        } else {
            player?.pause()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
        player?.isMuted = isMuted
    }
    
    func toggleFullScreen() {
        isFullScreen.toggle()
    }
    
    func togglePictureInPicture() {
        isPictureInPictureEnabled.toggle()
        // Implement PiP functionality
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }
    
    func skipForward() {
        seek(to: currentTime + 10)
    }
    
    func skipBackward() {
        seek(to: currentTime - 10)
    }
    
    // MARK: - Additional Actions
    
    func showInsight() {
        withAnimation(.spring()) {
            showingInSight = true
        }
    }
    
    func hideInsight() {
        withAnimation(.spring()) {
            showingInSight = false
        }
    }
    
    func continueWatching() {
        withAnimation(.spring()) {
            isFullScreenPlayer = true
            showingInSight = false  // Hide InSight if showing
            isPlaying = true        // Start playing
            player?.play()
        }
    }
    
    func showMoreOptions() {
        // Implement more options sheet
    }
    
    // MARK: - Observation
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration" {
            if let duration = player?.currentItem?.duration, duration.isValid {
                DispatchQueue.main.async {
                    self.duration = duration.seconds
                }
            }
        } else if keyPath == "status" {
            if let item = player?.currentItem {
                switch item.status {
                case .readyToPlay:
                    let duration = item.duration
                    if duration.isValid {
                        DispatchQueue.main.async {
                            self.duration = duration.seconds
                        }
                    }
                case .failed:
                    print("Failed to load video: \(String(describing: item.error))")
                case .unknown:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    deinit {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        player?.currentItem?.removeObserver(self, forKeyPath: "duration")
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    
    func playFromBeginning() {
        seek(to: 0)
        isPlaying = true
        player?.play()
    }
    
    func showDetails() {
        // Implement details view presentation
    }
    
    func formattedDuration() -> String {
        guard duration.isFinite && duration > 0 else { return "" }
        
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        
        if hours > 0 {
            return "\(hours)hr \(minutes)min"
        } else {
            return "\(minutes)min"
        }
    }
    
    func setPlaybackSpeed(_ speed: Double) {
        playbackRate = Float(speed)
        player?.rate = playbackRate
    }
    
    func formatTime(_ timeInSeconds: Double) -> String {
        guard timeInSeconds.isFinite && timeInSeconds >= 0 else { return "00:00" }
        
        let hours = Int(timeInSeconds) / 3600
        let minutes = Int(timeInSeconds) / 60 % 60
        let seconds = Int(timeInSeconds) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
} 