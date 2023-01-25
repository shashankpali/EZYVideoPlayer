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

public enum PlayerMenu: String {
    case fit, fill, stretch, hd = "720px", sd = "480px", off, english
    
    static var allCases: [(title: String, item: [PlayerMenu])] {
        return [("Subtitle", [.off, .english]),
                ("Quality", [.hd, .sd]),
                ("Aspect Ratio", [.fit, .fill, .stretch])]
    }
}

internal enum PlayerObserverKey: String {
    case status = "status", duration = "duration"
    
    static subscript(key: PlayerObserverKey) -> String { return key.rawValue }
}
