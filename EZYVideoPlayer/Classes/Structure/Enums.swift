//
//  Enums.swift
//  EZYVideoPlayer
//
//  Created by Shashank Pali on 24/01/23.
//

import Foundation

public enum PlayerStatus {
    case  buffering, buffered, playing, paused, ended, seekBackward, seekForward, failed(errorMsg: String?), unknown
}

internal enum PlayerObserverKey: String {
    case status = "status"
    case duration = "duration"
    
    static subscript(key: PlayerObserverKey) -> String { return key.rawValue }
}
