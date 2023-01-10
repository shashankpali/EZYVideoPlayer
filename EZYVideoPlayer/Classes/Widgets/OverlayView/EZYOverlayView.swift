//
//  EZYOverlayView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import UIKit
import AVFoundation

internal protocol EZYOverlayProtocol: EZYInteractionProtocol {
    func setup(on view: UIView, playerModel: EZYVideoPlayerModelProtocol?, andTitle: String)
    func keepVisible(_ visible:Bool)
    func playerCurrent(position: Float)
    func player(duration: Float)
}

internal final class EZYOverlayView: UIView, EZYOverlayProtocol {

    var model: EZYOverlayViewModel?
    var bottomView: EZYBottomViewProtocol?
    
    func setup(on view: UIView, playerModel: EZYVideoPlayerModelProtocol?, andTitle: String) {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        model = EZYOverlayViewModel(playerModel: playerModel, delegate: self)
        
        var controlsView = EZYControlsView.setup(on: self)
        controlsView.delegate = model
        
        bottomView = EZYBottomView.setup(on: self)
        bottomView?.addMenu()
        bottomView?.delegate = model
        
        var topView = EZYTopView.setup(on: self, withTitle: andTitle)
        topView.observeOrientation()
        topView.delegate = model
    }
    
    func didInteracted(withWidget: Bool) {
        model?.didInteracted(withWidget: withWidget)
    }
    
    func didChangeOrientation(isLandscape: Bool) {
        model?.didChangeOrientation(isLandscape: isLandscape)
    }
    
    func keepVisible(_ visible: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in self?.alpha = visible ? 1 : 0 }
    }
    
    func playerCurrent(position: Float) {
        bottomView?.playerCurrent(position: position)
    }
    
    func player(duration: Float) {
        bottomView?.player(duration: duration)
    }

}
