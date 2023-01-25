//
//  EZYVideoPlayerDelegate.swift
//  EZYVideoPlayer
//
//  Created by Shashank Pali on 06/01/23.
//

import Foundation

public protocol EZYVideoPlayerDelegate: AnyObject {
    func didChangedPlayer(status: PlayerStatus)
    func playerDidChanged(position: Float)
    func player(duration: Float)
    func didChangeOrientation(isLandscape: Bool)
    func didSelectMenu(item: PlayerMenu)
}

public extension EZYVideoPlayerDelegate {
    func didChangedPlayer(status: PlayerStatus) {}
    func playerDidChanged(position: Float) {}
    func player(duration: Float) {}
    func didChangeOrientation(isLandscape: Bool) {}
    func didSelectMenu(item: PlayerMenu) {}
}

internal protocol EZYTopActionDelegate: AnyObject, EZYInteractionProtocol {
    func didChangeOrientation(isLandscape: Bool)
}

internal protocol EZYControlActionDelegate: AnyObject, EZYInteractionProtocol {
    func didPrassedPlayPause() -> Bool
    func didPressedForward()
    func didPressedBackward()
}

internal protocol EZYBottomActionDelegate: AnyObject, EZYInteractionProtocol {
    func didSelectMenu(item: PlayerMenu)
    func didChangedSeeker(position: Float)
}

internal protocol EZYMenuDelegate: AnyObject {
    func didSelect(item: PlayerMenu)
}
