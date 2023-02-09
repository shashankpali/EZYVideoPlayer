//
//  ViewController.swift
//  EZYVideoPlayer
//
//  Created by Shashank Pali on 11/23/2022.
//  Copyright (c) 2022 Shashank Pali. All rights reserved.
//

import UIKit
import EZYVideoPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var playerView: EZYVideoPlayer!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: EZYVideoPlayerDelegate {
    
    func didChangeOrientation(isLandscape: Bool) {
        view.removeConstraint(heightConst)
        heightConst = playerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: isLandscape ? 1 : 0.3)
        view.addConstraint(heightConst)
    }
    
    func didChangedPlayer(status: PlayerStatus) {
        print("current status => ", status)
    }
    
    func playerDidChanged(position: Float) {
        print("current position => ", position)
    }
    
    func player(duration: Float) {
        print("total duration => ", duration)
    }
    
}
