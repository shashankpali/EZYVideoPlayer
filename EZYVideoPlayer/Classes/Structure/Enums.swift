//
//  Enums.swift
//  EZYVideoPlayer
//
//  Created by Shashank Pali on 24/01/23.
//

import Foundation

public enum PlayerStatus: Equatable {
    case  buffering, buffered, playing, paused, ended, seekBackward, seekForward, failed(errorMsg: String?), unknown
}

public enum PlayerMenu: String {
    case fit, fill, stretch, high = "720px", standard = "480px", off, english
    
    static var allCases: [(title: String, item: [PlayerMenu])] {
        return [("Subtitle", [.off, .english]),
                ("Quality", [.high, .standard]),
                ("Aspect Ratio", [.fit, .fill, .stretch])]
    }
}

internal enum PlayerObserverKey: String {
    case status, duration
    
    static subscript(key: PlayerObserverKey) -> String { return key.rawValue }
}
