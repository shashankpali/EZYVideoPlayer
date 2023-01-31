//
//  EZYVideoPlayerModelTest.swift
//  EZYVideoPlayer_Tests
//
//  Created by Shashank Pali on 31/01/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
import AVFoundation
@testable import EZYVideoPlayer

class EZYVideoPlayerModelTests: XCTestCase {
    var playerModel: EZYVideoPlayerModel!
    var mockDelegate: MockPlayerDelegate!
    
    override func setUp() {
        super.setUp()
        mockDelegate = MockPlayerDelegate()
        playerModel = EZYVideoPlayerModel(urlString: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
        playerModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        super.tearDown()
        playerModel = nil
        mockDelegate = nil
    }
    
    func testObserverCurrentTime() {
        // test that the time observer is added
        playerModel.observerCurrentTime()
        XCTAssertNotNil(playerModel.timeObserver)
    }
    
    func test_Status_Buffering() {
        // test that the status changed when delegate set
        XCTAssertEqual(PlayerStatus.buffering, mockDelegate.didChangedPlayerStatus)
    }
    
    func test_Status_Buffered() {
        // test that the delegate method is called when the status changes
        playerModel.observeValue(forKeyPath: PlayerObserverKey[.status], of: playerModel.player?.currentItem, change: [.newKey: AVPlayerItem.Status.readyToPlay.rawValue], context: nil)
        XCTAssertEqual(PlayerStatus.buffered, mockDelegate.didChangedPlayerStatus)
    }
    
    func test_Status_Duration() {
        let exp = expectation(description: "duration")
        playerModel.observeValue(forKeyPath: PlayerObserverKey[.duration], of: playerModel.player?.currentItem, change: [.newKey: 10], context: nil)
        mockDelegate.didReceivedDuration { status in
            exp.fulfill()
            XCTAssertTrue(status)
        }
        waitForExpectations(timeout: 5)
    }
    
    func test_Status_Changed() {
        playerModel.seek(withValue: 10)
        let exp = expectation(description: "changed")
        mockDelegate.didChanged { status in
            exp.fulfill()
            XCTAssertTrue(status)
        }
        waitForExpectations(timeout: 5)
    }
    
    func test_Status_Playing_And_Paused() {
        let _ = playerModel.isPlaying()
        XCTAssertEqual(PlayerStatus.paused, mockDelegate.didChangedPlayerStatus)
        
        let _ = playerModel.isPlaying()
        XCTAssertEqual(PlayerStatus.playing, mockDelegate.didChangedPlayerStatus)
    }
    
    func test_Status_SeekForward() {
        playerModel.seekForward()
        XCTAssertEqual(PlayerStatus.seekForward, mockDelegate.didChangedPlayerStatus)
    }
    
    func test_Status_SeekBackward() {
        playerModel.seekBackward()
        XCTAssertEqual(PlayerStatus.seekBackward, mockDelegate.didChangedPlayerStatus)
    }
    
    func test_Status_Configure() {
        playerModel.configureAs(menuItem: .fit)
        XCTAssertEqual(PlayerMenu.fit, mockDelegate.selectItem)
    }
    
    func test_layer_Mute() {
        playerModel.should(mute: true)
        XCTAssertTrue(playerModel.player!.isMuted)
    }
    
}

class MockPlayerDelegate: EZYVideoPlayerDelegate {
    var didChangedPlayerStatus: PlayerStatus = .unknown
    var didChanged: ((Bool) -> Void)?
    var selectItem = PlayerMenu.off
    
    func didChangedPlayer(status: PlayerStatus) {
        didChangedPlayerStatus = status
    }
    
    func didSelectMenu(item: PlayerMenu) {
        selectItem = item
    }
    
    func player(duration: Float) {
        commonCallback()
    }
    
    func playerDidChanged(position: Float) {
        commonCallback()
    }
    
    func commonCallback() {
        if let c = didChanged {
            c(true)
            didChanged = nil
        }
    }
    
    func didReceivedDuration(callback: @escaping (Bool) -> Void) {
        didChanged = callback
    }
    
    func didChanged(callback: @escaping (Bool) -> Void) {
        didChanged = callback
    }
}

