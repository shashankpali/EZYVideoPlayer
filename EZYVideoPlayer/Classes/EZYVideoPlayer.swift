//
//  EZYVideoPlayer.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit
import AVFoundation
import AVKit

@IBDesignable public class EZYVideoPlayer: UIView, EZYVideoPlayerProtocol {
    
    @IBInspectable var title: String = "Video title will be shown here"
    @IBInspectable var videoURL: String = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
    
    public weak var delegate: EZYVideoPlayerDelegate?
    private weak var avPlayerLayer: AVPlayerLayer?
    private var model: EZYVideoPlayerModelProtocol?
    
    private weak var overlayView: EZYOverlayProtocol?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func startWith(trailerURL: String, thumbnail: UIImage, mute: Bool) {
        setupPlayer(url: trailerURL)
        model?.should(mute: mute)
        self.layoutSubviews()
    }
    
    public func startWith(mainURL: String, title: String) {
        setupPlayer(url: mainURL)
        self.title = title
        setupComponents()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        avPlayerLayer?.frame = self.bounds
    }
    
    private func setupPlayer(url: String) {
        overlayView?.removeInstance()
        avPlayerLayer?.removeFromSuperlayer()
        model = nil
        
        model = EZYVideoPlayerModel(urlString: url)
        model?.delegate = self
        guard let player = model?.player else {return}
        
        let playerLayer = AVPlayerLayer(player: player)
        avPlayerLayer = playerLayer
        avPlayerLayer?.videoGravity = .resizeAspect
        avPlayerLayer?.backgroundColor = UIColor(white: 0, alpha: 1).cgColor
        
        guard avPlayerLayer != nil else { return }
        layer.addSublayer(avPlayerLayer!)
    }
    
    private func setupComponents() {
        let view = EZYOverlayView()
        overlayView = view
        overlayView?.setup(on: self, playerModel: model, andTitle: title)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, self.bounds.contains(touch.location(in: self))  else { return }
        overlayView?.didInteracted(withWidget: false)
    }
}

extension EZYVideoPlayer: EZYVideoPlayerDelegate {
    
    public func didChangedPlayer(status: PlayerStatus) {
        delegate?.didChangedPlayer(status: status)
    }
    
    public func playerDidChanged(position: Float) {
        overlayView?.playerCurrent(position: position)
        delegate?.playerDidChanged(position: position)
    }
    
    public func player(duration: Float) {
        overlayView?.player(duration: duration)
        delegate?.player(duration: duration)
    }
    
    public func didChangeOrientation(isLandscape: Bool) {
        delegate?.didChangeOrientation(isLandscape: isLandscape)
    }
    
    public func didSelectMenu(item: PlayerMenu) {
        switch item {
        case .fit:
            avPlayerLayer?.videoGravity = .resizeAspect
        case .fill:
            avPlayerLayer?.videoGravity = .resizeAspectFill
        case .stretch:
            avPlayerLayer?.videoGravity = .resize
        default:
            break
        }
        delegate?.didSelectMenu(item: item)
        layoutSubviews()
    }

}
