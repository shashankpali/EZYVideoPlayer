//
//  EZYBottomViewModel.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 23/11/22.
//

import Foundation
import AVFoundation

protocol EZYBottomViewModelProtocol {
    init(player: AVPlayer?, delegate: BottomViewUpdateUIProtocol?)
    func seekerUpdated(withValue: Float)
}

internal final class EZYBottomViewModel: NSObject, EZYBottomViewModelProtocol {
    
    var startedObserving = false
    weak var player : AVPlayer?
    var delegate: BottomViewUpdateUIProtocol?
    
    required init(player: AVPlayer?, delegate: BottomViewUpdateUIProtocol?) {
        self.player = player
        self.delegate = delegate
        super.init()
        
        observePlayerDuration()
    }
    
    deinit {
        self.player?.removeTimeObserver(self)
    }
    
    func seekerUpdated(withValue: Float) {
        player?.seek(to: CMTimeMake(value: Int64(withValue*1000), timescale: 1000))
        let currentTimeString = getTimeString(from: CMTimeMake(value: Int64(withValue*1000), timescale: 1000))
        delegate?.update(currentTimeString: currentTimeString)
    }
}

extension EZYBottomViewModel {
    
    func observePlayerDuration() {
        self.player?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            let endTimeString = getTimeString(from: (player?.currentItem?.duration)!)
            delegate?.update(endTimeString: endTimeString)
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
            
            self?.delegate?.update(seekerMinValue: 0)
            self?.delegate?.update(seekerMaxValue: Float(currentItem.duration.seconds))
            self?.delegate?.update(seekerCurrentValue: Float(currentItem.currentTime().seconds))
            self?.delegate?.update(currentTimeString: self?.getTimeString(from: currentItem.currentTime()) ?? "00:00")
        })
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hh = Int(totalSeconds/3600)
        let mm = Int(totalSeconds/60) % 60
        let ss = Int(totalSeconds.truncatingRemainder(dividingBy: 60)) % 60
        if hh > 0 {
            return String(format: "%d:%02d:%02d", hh,mm,ss)
        }else {
            return String(format: "%02d:%02d", mm,ss)
        }
    }
}
