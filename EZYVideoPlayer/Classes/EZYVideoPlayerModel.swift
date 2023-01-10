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
}

internal enum PlayerObserverKey: String {
    case status = "status"
    case duration = "duration"
    
    static subscript(key: PlayerObserverKey) -> String { return key.rawValue }
}

internal final class EZYVideoPlayerModel: NSObject, EZYVideoPlayerModelProtocol {
    
    var startedObserving = false
    var player: AVPlayer?
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
    
    func observerCurrentTime() {
        guard startedObserving == false else {return}
        startedObserving = true
        
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player?.currentItem else {return}
            self?.delegate?.playerDidChanged(position: Float(currentItem.currentTime().seconds))
        })
    }
    
    deinit {
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey[.status])
        player?.currentItem?.removeObserver(self, forKeyPath: PlayerObserverKey[.duration])
        player?.removeTimeObserver(self)
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
    
    func seek(withValue: Float) {
        player?.seek(to: CMTimeMake(value: Int64(withValue*1000), timescale: 1000))
        delegate?.playerDidChanged(position: withValue)
    }
    
    func seekForward() {
        delegate?.didChangedPlayer(status: .seekForward)
        seek { duration, currentTime in
            let newTime = currentTime + 10.0
            return newTime < (duration - 10) ? newTime : duration
        }
    }
    
    func seekBackward() {
        delegate?.didChangedPlayer(status: .seekBackward)
        seek { _, currentTime in
            let newTime = currentTime - 10.0
            return newTime < 0 ? 0 : newTime
        }
    }
    
    //MARK: Helper
    func seek(time: (_ duration: Float64, _ currentTime: Float64) -> Float64) {
        guard let duration = player?.currentItem?.duration else {return}
        guard let currentTime = player?.currentTime() else {return}
        
        let newTime = time(CMTimeGetSeconds(duration), CMTimeGetSeconds(currentTime))
        seek(withValue: Float(newTime))
    }
    
}
