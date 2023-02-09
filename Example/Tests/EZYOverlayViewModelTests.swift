//
//  EZYOverlayViewModelTests.swift
//  EZYVideoPlayer_Tests
//
//  Created by Shashank Pali on 31/01/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import XCTest
@testable import EZYVideoPlayer
import AVFoundation

class EZYOverlayViewModelTests: XCTestCase {
    var viewModel: EZYOverlayViewModel!
    var playerModel: EZYVideoPlayerModelMock!
    var delegate: EZYOverlayDelegateMock!
    
    override func setUp() {
        playerModel = EZYVideoPlayerModelMock(urlString: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
        delegate = EZYOverlayDelegateMock()
        viewModel = EZYOverlayViewModel(playerModel: playerModel, delegate: delegate)
    }
    
    func testStartTimer() {
        viewModel.startTimer()
        XCTAssertNotNil(viewModel.debounceTimer)
        let exp = expectation(description: "isVisible")
        delegate.timer { [unowned self] in
            exp.fulfill()
            XCTAssertFalse(viewModel.isVisible)
        }
        waitForExpectations(timeout: 6)
    }
    
    func testDidInteracted() {
        viewModel.isVisible = false
        viewModel.didInteracted(withWidget: false)
        XCTAssertTrue(viewModel.isVisible)
        XCTAssertTrue(delegate.keepVisibleCalled)
        XCTAssertTrue(delegate.keepVisibleValue)
        
        viewModel.didInteracted(withWidget: true)
        XCTAssertNotNil(viewModel.debounceTimer)
    }
    
    func testDidChangeOrientation() {
        viewModel.didChangeOrientation(isLandscape: true)
        XCTAssertTrue(playerModel.didChangeOrientationCalled)
        XCTAssertTrue(playerModel.didChangeOrientationValue)
    }
    
    func testDidPrassedPlayPause() {
        playerModel.isPlayingReturnValue = true
        let result = viewModel.didPrassedPlayPause()
        XCTAssertTrue(result)
        XCTAssertTrue(playerModel.isPlayingCalled)
        
        playerModel.isPlayingReturnValue = false
        let result2 = viewModel.didPrassedPlayPause()
        XCTAssertFalse(result2)
    }
    
    func testDidPressedForwardAndBackward() {
        viewModel.didPressedForward()
        XCTAssertTrue(playerModel.seekForwardCalled)
        
        viewModel.didPressedBackward()
        XCTAssertTrue(playerModel.seekBackwardCalled)
    }
    
    func testDidSelectMenu() {
        let menuItem = PlayerMenu.fit
        viewModel.didSelectMenu(item: menuItem)
        XCTAssertTrue(playerModel.configureAsCalled)
        XCTAssertEqual(playerModel.configureAsValue, menuItem)
    }
    
    func testDidChangedSeeker() {
        let position: Float = 0.5
        viewModel.didChangedSeeker(position: position)
        XCTAssertTrue(playerModel.seekCalled)
        XCTAssertEqual(playerModel.seekValue, position)
    }
}

// Mocks
class EZYVideoPlayerModelMock: EZYVideoPlayerModelProtocol, EZYVideoPlayerDelegate {
    var player: AVPlayer?
    var delegate: EZYVideoPlayerDelegate?
    
    var isPlayingCalled = false
    var isPlayingReturnValue = false
    
    var seekForwardCalled = false
    var seekBackwardCalled = false
    
    var seekCalled = false
    var seekValue: Float = 0
    
    var didChangeOrientationCalled = false
    var didChangeOrientationValue = false
    
    var configureAsCalled = false
    var configureAsValue: PlayerMenu = .fit
    
    func isPlaying() -> Bool {
        isPlayingCalled = true
        return isPlayingReturnValue
    }
    
    func seekForward() {
        seekForwardCalled = true
    }
    
    func seekBackward() {
        seekBackwardCalled = true
    }
    
    func seek(withValue position: Float) {
        seekCalled = true
        seekValue = position
    }
    
    func didChangeOrientation(isLandscape: Bool) {
        didChangeOrientationCalled = true
        didChangeOrientationValue = isLandscape
    }
    
    func configureAs(menuItem: PlayerMenu) {
        configureAsCalled = true
        configureAsValue = menuItem
    }
    
    required init(urlString: String) {
        delegate = self
    }
    
    func should(mute: Bool) {}
}

class EZYOverlayDelegateMock: EZYOverlayProtocol {

    var keepVisibleCalled = false
    var keepVisibleValue = false
    var timerCallback: (() -> Void)?
    
    func timer(callback: @escaping () -> Void) {
        timerCallback = callback
    }
    
    func keepVisible(_ visible: Bool) {
        keepVisibleCalled = true
        keepVisibleValue = visible
        if let callback = timerCallback {
            callback()
            timerCallback = nil
        }
    }
    
    func setup(on view: UIView, playerModel: EZYVideoPlayerModelProtocol?, andTitle: String) {}
    
    func playerCurrent(position: Float) {}
    
    func player(duration: Float) {}
    
    func removeInstance() {}
    
    func didInteracted(withWidget: Bool) {}
}
