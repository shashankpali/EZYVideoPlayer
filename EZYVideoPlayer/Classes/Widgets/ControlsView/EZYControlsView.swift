//
//  EZYControlsView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit

internal protocol EZYControlActionDelegate {
    func didPressedPlay(shouldPlay: Bool)
    func didPressedForward()
    func didPressedBackward()
}

internal protocol EZYControlProtocol {
    var delegate : EZYControlActionDelegate? { get set }
    static func setup(on view: UIView) -> EZYControlProtocol
}

internal final class EZYControlsView: UIView, EZYControlProtocol {

    @IBOutlet weak var playPauseBtn: UIButton!
    var isPlaying = false
    var delegate : EZYControlActionDelegate?

    
    static func setup(on view: UIView) -> EZYControlProtocol {
        
        let controls = EZYControlsView.instantiate(withOwner: nil)
        
        view.addSubview(controls)
        
        controls.translatesAutoresizingMaskIntoConstraints = false
        controls.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        controls.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return controls
    }
    
    //MARK: - User interaction
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        isPlaying = !isPlaying
        let img = isPlaying ? "pause.fill" : "play.fill"
        playPauseBtn.setImage(UIImage(systemName: img), for: .normal)
        
        delegate?.didPressedPlay(shouldPlay: isPlaying)
    }
    
    @IBAction func forwardTapped(_ sender: UIButton) {
        delegate?.didPressedForward()
    }
    
    @IBAction func backwardTapped(_ sender: UIButton) {
        delegate?.didPressedBackward()
    }
}
