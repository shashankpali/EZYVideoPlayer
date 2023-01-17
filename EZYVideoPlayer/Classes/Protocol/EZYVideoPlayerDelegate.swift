//
//  EZYVideoPlayerDelegate.swift
//  EZYVideoPlayer
//
//  Created by Shashank Pali on 06/01/23.
//

import Foundation

public enum PlayerStatus {
    case  buffering, buffered, playing, paused, ended, seekBackward, seekForward, failed(errorMsg: String?), unknown
}

public protocol EZYVideoPlayerDelegate: AnyObject {
    func didChangedPlayer(status: PlayerStatus)
    func playerDidChanged(position: Float)
    func player(duration: Float)
    func didChangeOrientation(isLandscape: Bool)
}

public extension EZYVideoPlayerDelegate {
    func didChangedPlayer(status: PlayerStatus) {}
    func playerDidChanged(position: Float) {}
    func player(duration: Float) {}
    func didChangeOrientation(isLandscape: Bool) {}
}
