//
//  EZYVideoPlayer.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit
import AVFoundation
import AVKit

public protocol EZYVideoPlayerProtocol {
    var delegate: EZYVideoPlayerDelegate? { get set }
    
    func startWith(thumbnail: UIImage, mainURL: String)
    func startWith(trailerURL: String, mainURL: String)
    func startWith(mainURL: String)
}

@IBDesignable public class EZYVideoPlayer: UIView {
    
    @IBInspectable var title: String = "Video title will be showen here"
    @IBInspectable var videoURL: String = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    
    public var delegate: EZYVideoPlayerDelegate?
    private var model: EZYVideoPlayerModelProtocol?
    private var avPlayerLayer: AVPlayerLayer?
    
    private var overlayView : EZYOverlayProtocol = EZYOverlayView()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupPlayer()
        setupComponents()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        avPlayerLayer?.frame = self.bounds
    }
    
    private func setupPlayer() {
        
        model = EZYVideoPlayerModel(urlString: videoURL)
        model?.delegate = self
        guard let player = model?.player else {return}
        
        avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer?.videoGravity = .resizeAspect
        avPlayerLayer?.backgroundColor = UIColor(white: 0, alpha: 1).cgColor
        
        guard (avPlayerLayer != nil) else { return }
        layer.addSublayer(avPlayerLayer!)
    }
    
    private func setupComponents() {
        overlayView.setup(on: self, playerModel: model, andTitle: title)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.bounds.contains(touch.location(in: self))  else { return }
        
        overlayView.didInteracted(withWidget: false)
    }
    
}

extension EZYVideoPlayer: EZYVideoPlayerDelegate {
    
    public func didChangedPlayer(status: PlayerStatus) {
        delegate?.didChangedPlayer(status: status)
    }
    
    public func playerDidChanged(position: Float) {
        overlayView.playerCurrent(position: position)
        delegate?.playerDidChanged(position: position)
    }
    
    public func player(duration: Float) {
        overlayView.player(duration: duration)
        delegate?.player(duration: duration)
    }
    
    public func didChangeOrientation(isLandscape: Bool) {
        delegate?.didChangeOrientation(isLandscape: isLandscape)
    }

}


