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
    func startWith(thumbnail: UIImage, mainURL: String)
    func startWith(trailerURL: UIImage, mainURL: String)
    func startWith(mainURL: String)
}

@IBDesignable public class EZYVideoPlayer: UIView {
    
    @IBInspectable var videoURL: String = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    
    let overlayView : EZYOverlayProtocol = EZYOverlayView()
    
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
        guard let url = URL(string: videoURL) else {return}
        avPlayer = AVPlayer(url: url)
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = .resizeAspect
        avPlayerLayer?.backgroundColor = UIColor(white: 0, alpha: 1).cgColor
        
        guard (avPlayerLayer != nil) else { return }
        layer.addSublayer(avPlayerLayer!)
    }
    
    private func setupComponents() { overlayView.setup(on: self, withPlayer: avPlayer) }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.bounds.contains(touch.location(in: self))  else { return }
        
        overlayView.didInteracted(withWidget: false)
    }
    
}
