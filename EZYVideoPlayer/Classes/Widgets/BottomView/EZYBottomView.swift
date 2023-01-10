//
//  EZYBottomView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit
import AVFoundation

internal protocol EZYBottomViewProtocol {
    var delegate: EZYOverlayViewModelProtocol? { get set }
    
    static func setup(on view: UIView) -> EZYBottomViewProtocol
    func addMenu()
    
    func playerCurrent(position: Float)
    func player(duration: Float)
}

internal final class EZYBottomView: UIView, EZYBottomViewProtocol {
   
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var seeker: UISlider!
    @IBOutlet weak var menuBtn: UIButton!
    //
    var delegate: EZYOverlayViewModelProtocol?
    
    static func setup(on view: UIView) -> EZYBottomViewProtocol {
        
        let bottom = EZYBottomView.instantiate(withOwner: nil)
        view.addSubview(bottom)
        
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        return bottom
    }
    
    //MARK: - User action
    
    @IBAction func seekerChanged(_ sender: UISlider) {
        delegate?.playerCurrent(position: sender.value)
        delegate?.didInteracted(withWidget: true)
    }
    
    //MARK: - Update UI
    
    func playerCurrent(position: Float) {
        seeker.value = position
        currentTimeLabel.text = getTimeString(from: position)
    }
    
    func player(duration: Float) {
        seeker.minimumValue = 0
        seeker.maximumValue = duration
        endTimeLabel.text = getTimeString(from: duration)
    }
    
    func getTimeString(from totalSeconds: Float) -> String {
        let hh = Int(totalSeconds/3600)
        let mm = Int(totalSeconds/60) % 60
        let ss = Int(totalSeconds.truncatingRemainder(dividingBy: 60)) % 60
        if hh > 0 {
            return String(format: "%d:%02d:%02d", hh,mm,ss)
        }else {
            return String(format: "%02d:%02d", mm,ss)
        }
    }
    
}

extension EZYBottomView: EZYMenuProtocol {
    
    func addMenu() {
        let me1 = UIMenu.forTitle("Subtitles", children: ["Off", "English"], delegate: self)
        let me2 = UIMenu.forTitle("Quality", children: ["480p", "720p"], delegate: self)
        let main = UIMenu(title: "", options: .displayInline, children: [me1,me2])
        
        menuBtn.menu = main
    }
    
    func didSelectMenu(item: String, child: String) {
        delegate?.didInteracted(withWidget: true)
    }
}
