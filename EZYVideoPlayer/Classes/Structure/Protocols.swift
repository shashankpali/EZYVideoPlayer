//
//  EZYInteractionProtocol.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 22/11/22.
//

import Foundation
import AVFoundation

public protocol EZYVideoPlayerProtocol {
    var delegate: EZYVideoPlayerDelegate? { get set }
    
    func startWith(trailerURL: String, thumbnail: UIImage, mute: Bool)
    func startWith(mainURL: String)
}

internal protocol EZYVideoPlayerModelProtocol: AnyObject {
    var player: AVPlayer? {get}
    var delegate: EZYVideoPlayerDelegate? {get set}
    init(urlString: String)
    
    func seekForward()
    func seekBackward()
    func seek(withValue: Float)
    func isPlaying() -> Bool
    func should(mute: Bool)
    func configureAs(menuItem: PlayerMenu)
}

internal protocol EZYInteractionProtocol: AnyObject {
    func didInteracted(withWidget: Bool)
}

internal protocol EZYOverlayProtocol: AnyObject, EZYInteractionProtocol {
    func setup(on view: UIView, playerModel: EZYVideoPlayerModelProtocol?, andTitle: String)
    func keepVisible(_ visible:Bool)
    func playerCurrent(position: Float)
    func player(duration: Float)
    func removeInstance()
}

internal protocol EZYOverlayViewModelProtocol: EZYInteractionProtocol {
    init(playerModel: EZYVideoPlayerModelProtocol?, delegate: EZYOverlayProtocol)
}

internal protocol EZYTopViewProtocol {
    var delegate: EZYTopActionDelegate? { get set }
    
    static func setup(on view: UIView, withTitle: String?) -> EZYTopViewProtocol
    func observeOrientation()
}

internal protocol EZYControlProtocol {
    var delegate : EZYControlActionDelegate? { get set }
    static func setup(on view: UIView) -> EZYControlProtocol
}

internal protocol EZYBottomViewProtocol {
    var delegate: EZYBottomActionDelegate? { get set }
    
    static func setup(on view: UIView) -> EZYBottomViewProtocol
    func addMenu()
    
    func seekerCurrent(position: Float)
    func seekerMax(duration: Float)
}
