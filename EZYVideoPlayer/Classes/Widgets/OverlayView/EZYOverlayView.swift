//
//  EZYOverlayView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import UIKit
import AVFoundation

protocol EZYOverlayProtocol: EZYInteractionProtocol {
    func setup(on view: UIView, withPlayer: AVPlayer?, andTitle: String)
    func keepVisible(_ visible:Bool)
}

internal final class EZYOverlayView: UIView, EZYOverlayProtocol {
    
    var model: EZYOverlayViewModelProtocol?
    
    func setup(on view: UIView, withPlayer: AVPlayer?, andTitle: String) {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        model = EZYOverlayViewModel(player: withPlayer, delegate: self)
        
        var controlsView = EZYControlsView.setup(on: self)
        controlsView.delegate = model
        
        var bottomView = EZYBottomView.setup(on: self, withPlayer: withPlayer)
        bottomView.addMenu()
        bottomView.delegate = model
        
        var topView = EZYTopView.setup(on: self, withTitle: andTitle)
        topView.observeOrientation()
        topView.delegate = model
    }
    
    func didInteracted(withWidget: Bool) {
        model?.didInteracted(withWidget: withWidget)
    }
    
    func keepVisible(_ visible: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in self?.alpha = visible ? 1 : 0 }
    }

}
