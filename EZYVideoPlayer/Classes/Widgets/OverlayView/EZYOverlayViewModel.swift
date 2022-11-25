//
//  EZYOverlayViewModel.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import Foundation
import AVFoundation

protocol EZYOverlayViewModelProtocol: EZYInteractionProtocol, EZYControlActionProtocol {
    init(player: AVPlayer?, delegate: EZYOverlayProtocol)
}

internal final class EZYOverlayViewModel: EZYOverlayViewModelProtocol {
    
    weak var player : AVPlayer?
    var delegate: EZYOverlayProtocol?
    var isVisible = true
    var debounceTimer: Timer?
    
    required init(player: AVPlayer?, delegate: EZYOverlayProtocol) {
        self.player = player
        self.delegate = delegate
        
        startTimer()
    }
    
    func startTimer() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
            self?.isVisible = false
            self?.delegate?.keepVisible(false)
        }
    }
}

extension EZYOverlayViewModel {
    
    //MARK: EZYInteractionProtocol
    func didInteracted(withWidget: Bool) {
        guard withWidget == false else {return startTimer()}
        isVisible = !isVisible
        if isVisible { startTimer() }
        delegate?.keepVisible(isVisible)
    }
    
    //MARK: EZYControlActionProtocol
    func didPressedPlay(shouldPlay: Bool) {
        startTimer()
        shouldPlay ? player?.play() : player?.pause()
    }
    
    func didPressedForward() {
        startTimer()
        seek { duration, currentTime in
            let newTime = currentTime + 10.0
            return newTime < (duration - 10) ? newTime : duration
        }
    }
    
    func didPressedBackward() {
        startTimer()
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
        let time = CMTimeMake(value: Int64(newTime)*1000, timescale: 1000)
        player?.seek(to: time)
    }
}
