//
//  EZYOverlayView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import UIKit
import AVFoundation

internal protocol EZYOverlayProtocol: AnyObject, EZYInteractionProtocol {
    func setup(on view: UIView, playerModel: EZYVideoPlayerModelProtocol?, andTitle: String)
    func keepVisible(_ visible:Bool)
    func playerCurrent(position: Float)
    func player(duration: Float)
    func removeInstance()
}

internal final class EZYOverlayView: UIView, EZYOverlayProtocol {

    var model: EZYOverlayViewModelProtocol?
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
        controlsView.delegate = model as? EZYControlActionDelegate
        
        bottomView = EZYBottomView.setup(on: self)
        bottomView?.addMenu()
        bottomView?.delegate = model as? EZYBottomActionDelegate
        
        var topView = EZYTopView.setup(on: self, withTitle: andTitle)
        topView.observeOrientation()
        topView.delegate = model as? EZYTopActionDelegate
    }
    
    func didInteracted(withWidget: Bool) {
        model?.didInteracted(withWidget: withWidget)
    }
    
    func keepVisible(_ visible: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in self?.alpha = visible ? 1 : 0 }
    }
    
    func playerCurrent(position: Float) {
        bottomView?.seekerCurrent(position: position)
    }
    
    func player(duration: Float) {
        bottomView?.seekerMax(duration: duration)
    }
    
    func removeInstance() {
        self.removeFromSuperview()
    }
}
