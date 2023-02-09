//
//  EZYBottomView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit
import AVFoundation

internal final class EZYBottomView: UIView, EZYBottomViewProtocol {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var seeker: UISlider!
    @IBOutlet weak var menuBtn: UIButton!
    
    weak var delegate: EZYBottomActionDelegate?
    
    static func setup(on view: UIView) -> EZYBottomViewProtocol {
        
        let bottom = EZYBottomView.instantiate(withOwner: nil)
        view.addSubview(bottom)
        
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        return bottom
    }
    
    // MARK: - User action
    
    @IBAction func seekerChanged(_ sender: UISlider) {
        delegate?.didInteracted(withWidget: true)
        delegate?.didChangedSeeker(position: sender.value)
    }
    
    // MARK: - Update UI
    
    func seekerCurrent(position: Float) {
        seeker.value = position
        currentTimeLabel.text = getTimeString(from: position)
    }
    
    func seekerMax(duration: Float) {
        seeker.minimumValue = 0
        seeker.maximumValue = duration
        endTimeLabel.text = getTimeString(from: duration)
    }
    
    /// This function takes in a total number of seconds in the form of a float, and returns a formatted time string in the form of "HH:MM:SS" or "MM:SS" depending on whether the total number of seconds is greater than or equal to one hour.
    func getTimeString(from totalSeconds: Float) -> String {
        // calculate the number of hours, minutes and seconds
        let hours = Int(totalSeconds/3600)
        let minutes = Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60)) % 60
        // check if the total seconds is greater than or equal to one hour
        if hours > 0 {
            // format the string to include hours if greater than or equal to one hour
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            // format the string without hours if less than one hour
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
}

extension EZYBottomView: EZYMenuDelegate {
    
    func addMenu() {
        let item = PlayerMenu.allCases.map {
            UIMenu.forTitle($0, children: $1, delegate: self)
        }
        let main = UIMenu(title: "", options: .displayInline, children: item)
        
        menuBtn.menu = main
    }
    
    func didSelect(item: PlayerMenu) {
        delegate?.didSelectMenu(item: item)
    }
}
