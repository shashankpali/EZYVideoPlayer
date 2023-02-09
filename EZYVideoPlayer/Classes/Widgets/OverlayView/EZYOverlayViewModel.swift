//
//  EZYOverlayViewModel.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import Foundation
import AVFoundation

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

extension EZYOverlayViewModel: EZYTopActionDelegate, EZYControlActionDelegate, EZYBottomActionDelegate {
   
    // MARK: EZYInteractionProtocol
    func didInteracted(withWidget: Bool) {
        guard withWidget == false else {return startTimer()}
        isVisible = !isVisible
        if isVisible { startTimer() }
        delegate?.keepVisible(isVisible)
    }
    
    // MARK: EZYTopActionDelegate
    func didChangeOrientation(isLandscape: Bool) {
        playerModel?.delegate?.didChangeOrientation(isLandscape: isLandscape)
    }
    
    // MARK: EZYControlActionProtocol
    func didPrassedPlayPause() -> Bool {
        return playerModel?.isPlaying() ?? false
    }
    
    func didPressedForward() {
        playerModel?.seekForward()
    }
    
    func didPressedBackward() {
        playerModel?.seekBackward()
    }
    
    // MARK: EZYBottomActionDelegate
    func didSelectMenu(item: PlayerMenu) {
        playerModel?.configureAs(menuItem: item)
    }
    
    func didChangedSeeker(position: Float) {
        playerModel?.seek(withValue: position)
    }
}
