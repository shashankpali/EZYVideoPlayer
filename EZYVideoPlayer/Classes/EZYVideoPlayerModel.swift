//
//  EZYVideoPlayerModel.swift
//  EZYVideoPlayer
//
//  Created by Shashank Pali on 09/01/23.
//

import Foundation
import AVFoundation

internal protocol EZYVideoPlayerModelProtocol {
    var player: AVPlayer? {get}
    var delegate: EZYVideoPlayerDelegate? {get set}
    init(urlString: String)
    
    func seekForward()
    func seekBackward()
    func seek(withValue: Float)
    func should(play: Bool)
    func should(mute: Bool)
}

internal enum PlayerObserverKey: String {
    case status = "status"
    case duration = "duration"
    
    static subscript(key: PlayerObserverKey) -> String { return key.rawValue }
}

internal final class EZYVideoPlayerModel: NSObject, EZYVideoPlayerModelProtocol {
    
    var player: AVPlayer?
    var timeObserver: Any?
    var delegate: EZYVideoPlayerDelegate? {
        didSet {
            delegate?.didChangedPlayer(status: .buffering)
        }
    }
    
    required init(urlString: String) {
        super.init()
        
        guard let url = URL(string: urlString) else {return}
        let asset = AVAsset(url: url)
        let requiredAssetKeys = ["playable", "hasProtectedContent"]
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: requiredAssetKeys)
        
        player = AVPlayer(playerItem: playerItem)
        
        observePlayer()
    }
    
    func observePlayer() {
        player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey[.status], options: [.old, .new], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: PlayerObserverKey[.duration], options: [.new, .initial], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == PlayerObserverKey[.status] {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                delegate?.didChangedPlayer(status: .buffered)
            case .failed:
                delegate?.didChangedPlayer(status: .failed(errorMsg: player?.currentItem?.error?.localizedDescription))
            case .unknown:
                delegate?.didChangedPlayer(status: .unknown)
            @unknown default:
                delegate?.didChangedPlayer(status: .unknown)
            }
        }else if keyPath == PlayerObserverKey[.duration], let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            delegate?.player(duration: Float(duration))
            observerCurrentTime()
        }
    }
    
    /// This function is used to observe the current time of an AVPlayer. It sets up a periodic time observer that calls a callback function on the main queue at a specified interval. The callback function passes the current time to the delegate.
    func observerCurrentTime() {
        // check if observer is already started
        guard timeObserver == nil else {return}
        // set the time interval for the observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        // add the observer, using a closure as the callback function
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player?.currentItem else {return}
            // call delegate method to pass the current time
            self?.delegate?.playerDidChanged(position: Float(currentItem.currentTime().seconds))
        })
    }
    
    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey[.status])
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey[.duration])
        guard let t = timeObserver else {return}
        player?.removeTimeObserver(t)
    }
}

//MARK: - Actions

extension EZYVideoPlayerModel {
    
    func should(play: Bool) {
        if play {
            player?.play()
            delegate?.didChangedPlayer(status: .playing)
        }else {
            player?.pause()
            delegate?.didChangedPlayer(status: .paused)
        }
    }
    
    func should(mute: Bool) {
        player?.isMuted = mute
    }
    
    /// This function allows for seeking through a media player, such as a video or audio player. It takes in a value (withValue) as a parameter, representing the position in seconds that the player should seek to.
    func seek(withValue: Float) {
        // The player's seek method is called with a CMTime object created using the value and timescale of 1000.
        player?.seek(to: CMTimeMake(value: Int64(withValue*1000), timescale: 1000))
        // The playerDidChanged method of the delegate is called, passing in the position (withValue) as a parameter.
        delegate?.playerDidChanged(position: withValue)
    }
    
    /// This function allows for seeking forward in a media player. It calls the didChangedPlayer method on the delegate with the status "seekForward", then calls the seek function with a closure that calculates the new time to seek to.
    func seekForward() {
        // The didChangedPlayer method of the delegate is called with the status "seekForward".
        delegate?.didChangedPlayer(status: .seekForward)
        // The seek function is called with a closure that calculates the new time to seek to by adding 10 seconds
        // to the current time. The closure ensures that the new time is not more than 10 seconds from the end of the duration
        seek { duration, currentTime in
            let newTime = currentTime + 10.0
            return newTime < (duration - 10) ? newTime : duration
        }
    }
    
    /// This function allows for seeking forward in a media player. It calls the didChangedPlayer method on the delegate with the status "seekBackward", then calls the seek function with a closure that calculates the new time to seek to.
    func seekBackward() {
        // The didChangedPlayer method of the delegate is called with the status "seekBackward".
        delegate?.didChangedPlayer(status: .seekBackward)
        // The seek function is called with a closure that calculates the new time to seek to by subtracting 10 seconds
        // from the current time. The closure ensures that the new time is not less than 0 seconds
        seek { _, currentTime in
            let newTime = currentTime - 10.0
            return newTime < 0 ? 0 : newTime
        }
    }
    
    /// This function is a helper function for the seekForward and seekBackward functions. It takes in a closure (time) that calculates the new time to seek to. If both are not nil, it calls the closure with the duration and current time in seconds and then calls the seek function with the new time.
    func seek(time: (_ duration: Float64, _ currentTime: Float64) -> Float64) {
        guard let duration = player?.currentItem?.duration else {return}
        guard let currentTime = player?.currentTime() else {return}
        
        let newTime = time(CMTimeGetSeconds(duration), CMTimeGetSeconds(currentTime))
        seek(withValue: Float(newTime))
    }
    
}
