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
    
    var playerModel : EZYVideoPlayerModelProtocol?
    var delegate: EZYOverlayProtocol?
    var isVisible = true
    var debounceTimer: Timer?
    
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
    func didPressedPlay(shouldPlay: Bool) {
        startTimer()
        playerModel?.should(play: shouldPlay)
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
