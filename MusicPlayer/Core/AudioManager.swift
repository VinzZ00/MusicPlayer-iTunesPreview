//
//  AudioManager.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 02/03/25.
//

import AVFoundation
import Combine

class AudioManager: NSObject {
    static let shared: AudioManager = AudioManager()
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    private var playerProgress: CurrentValueSubject<(Float64, Float64), Never> = CurrentValueSubject((0,0))
    
    private override init() {}
    
    func isPlaying() -> Bool {
        if let player {
            return player.rate > 0
        } else {
            return false
        }
    }
    
    func playPause() {
        if isPlaying() {
            player?.pause()
        } else {
            player?.play()
        }
    }
    
    func play(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("AudioManager: invalid URL")
            return
        }
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        removeTimeObserver() // Remove observer to prevent memory leaks

        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        
        addPeriodicTimeObserver()
    }
    
    private func addPeriodicTimeObserver() {
        guard let player = player else { return }
        
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
            
            self?.playerProgress.send((currentTime, duration))
        }
    }
    
    func seek(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
    
    func getCurrentTime() -> Double {
        return player?.currentTime().seconds ?? 0
    }
    
    func getDuration() -> Double {
        return player?.currentItem?.duration.seconds ?? 0
    }
    
    func removeTimeObserver() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    
    func getProgressPublisher() -> AnyPublisher<(Float64, Float64), Never> {
        return playerProgress.eraseToAnyPublisher()
    }
}
