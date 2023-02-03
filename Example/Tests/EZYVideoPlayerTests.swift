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
    
    var videoPlayer: EZYVideoPlayer!
    var mockDelegate: MockEZYVideoPlayerDelegate!
    
    override func setUp() {
        super.setUp()
        videoPlayer = EZYVideoPlayer()
        mockDelegate = MockEZYVideoPlayerDelegate()
        videoPlayer.delegate = mockDelegate
        
        let mainURL = "http://example.com/main"
        let title = "Test Video"
        videoPlayer.startWith(mainURL: mainURL, title: title)
    }
    
    override func tearDown() {
        super.tearDown()
        videoPlayer = nil
        mockDelegate = nil
    }
    
    func testStartWithMainURL() {
        XCTAssertNotNil(videoPlayer)
    }
    
    func testStartWithTrailer() {
        videoPlayer.startWith(trailerURL: "", thumbnail: UIImage(), mute: true)
        XCTAssertNotNil(videoPlayer)
    }
    
    func testDidChangedPlayerStatus() {
        videoPlayer.didChangedPlayer(status: .playing)
        XCTAssertTrue(mockDelegate.didPlayerStatusChanged)
    }
    
    func testDidChangedPlayerPosition() {
        videoPlayer.playerDidChanged(position: 10)
        XCTAssertTrue(mockDelegate.didChangedPosition)
    }
    
    func testDidReceivedPlayerDuration() {
        videoPlayer.player(duration: 10)
        XCTAssertTrue(mockDelegate.didReceivedDuration)
    }
    
    func testDidChangedPlayerOrientation() {
        videoPlayer.didChangeOrientation(isLandscape: true)
        XCTAssertTrue(mockDelegate.didOriente)
    }
    
    func testDidSelectPlayerMenu() {
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
