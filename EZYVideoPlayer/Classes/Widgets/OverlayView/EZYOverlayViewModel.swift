//
//  EZYOverlayViewModel.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import Foundation
import AVFoundation

internal protocol EZYOverlayViewModelProtocol: EZYInteractionProtocol, EZYControlActionDelegate {
    init(playerModel: EZYVideoPlayerModelProtocol?, delegate: EZYOverlayProtocol)
    
    func playerCurrent(position: Float)
}

internal final class EZYOverlayViewModel: EZYOverlayViewModelProtocol {
    
    weak var playerModel : EZYVideoPlayerModelProtocol?
    weak var delegate: EZYOverlayProtocol?
    weak var debounceTimer: Timer?
    var isVisible = true
    
    required init(playerModel: EZYVideoPlayerModelProtocol?, delegate: EZYOverlayProtocol) {
        self.playerModel = playerModel
        self.delegate = delegate
        
        startTimer()
    }
    
    func startTimer() {
        debounceTimer?.invalidate()
        debounceTimer = nil
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
            self?.isVisible = false
            self?.delegate?.keepVisible(false)
        }
    }
}

extension EZYOverlayViewModel {
    
    //MARK: EZYInteractionProtocol
    func didChangeOrientation(isLandscape: Bool) {
        playerModel?.delegate?.didChangeOrientation(isLandscape: isLandscape)
    }
    
    func didInteracted(withWidget: Bool) {
        guard withWidget == false else {return startTimer()}
        isVisible = !isVisible
        if isVisible { startTimer() }
        delegate?.keepVisible(isVisible)
    }
    
    func playerCurrent(position: Float) {
        playerModel?.seek(withValue: position)
    }
    
    //MARK: EZYControlActionProtocol
    func didPrassedPlayPause() -> Bool {
        startTimer()
        return playerModel?.isPlaying() ?? false
    }
    
    func didPressedForward() {
        startTimer()
        playerModel?.seekForward()
    }
    
    func didPressedBackward() {
        startTimer()
        playerModel?.seekBackward()
    }
}
