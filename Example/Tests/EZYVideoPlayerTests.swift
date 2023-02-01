//
//  EZYVideoPlayerTests.swift
//  EZYVideoPlayer_Tests
//
//  Created by Shashank Pali on 01/02/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import EZYVideoPlayer

class EZYVideoPlayerTests: XCTestCase {
    
    func testStartWithMainURL() {
        let videoPlayer = EZYVideoPlayer()
        let mockDelegate = MockEZYVideoPlayerDelegate()
        videoPlayer.delegate = mockDelegate
        
        let mainURL = "http://example.com/main"
        let title = "Test Video"
        
        videoPlayer.startWith(mainURL: mainURL, title: title)
        XCTAssertNotNil(videoPlayer)
        
        videoPlayer.didChangedPlayer(status: .playing)
        XCTAssertTrue(mockDelegate.didPlayerStatusChanged)
        
        videoPlayer.playerDidChanged(position: 10)
        XCTAssertTrue(mockDelegate.didChangedPosition)
        
        videoPlayer.player(duration: 10)
        XCTAssertTrue(mockDelegate.didReceivedDuration)
        
        videoPlayer.didChangeOrientation(isLandscape: true)
        XCTAssertTrue(mockDelegate.didOriente)
        
        videoPlayer.didSelectMenu(item: .fit)
        XCTAssertTrue(mockDelegate.didSelectMenu)
    }
}

class MockEZYVideoPlayerDelegate: EZYVideoPlayerDelegate {
    
    var didPlayerStatusChanged = false
    var didChangedPosition = false
    var didReceivedDuration = false
    var didSelectMenu = false
    var didOriente = false
    
    func didChangedPlayer(status: PlayerStatus) {
        didPlayerStatusChanged = true
    }
    
    func playerDidChanged(position: Float) {
        didChangedPosition = true
    }
    
    func player(duration: Float) {
        didReceivedDuration = true
    }
    
    func didChangeOrientation(isLandscape: Bool) {
        didOriente = true
    }
    
    func didSelectMenu(item: PlayerMenu) {
        didSelectMenu = true
    }
}
