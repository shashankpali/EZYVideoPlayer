//
//  EZYBottomView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit
import AVFoundation

protocol BottomViewUpdateUIProtocol {
    func update(currentTimeString: String)
    func update(endTimeString: String)
    func update(seekerMinValue: Float)
    func update(seekerCurrentValue: Float)
    func update(seekerMaxValue: Float)
}

protocol EZYBottomViewProtocol {
    var delegate: EZYInteractionProtocol? { get set }
    
    static func setup(on view: UIView, withPlayer: AVPlayer?) -> EZYBottomViewProtocol
    func addMenu()
}

internal final class EZYBottomView: UIView, EZYBottomViewProtocol {
   
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var seeker: UISlider!
    
    @IBOutlet weak var menuBtn: UIButton!
    //
    var delegate: EZYInteractionProtocol?
    var model: EZYBottomViewModelProtocol?
    
    static func setup(on view: UIView, withPlayer: AVPlayer?) -> EZYBottomViewProtocol {
        
        let bottom = EZYBottomView.instantiate(withOwner: nil)
        bottom.model = EZYBottomViewModel(player: withPlayer, delegate: bottom)
        
        view.addSubview(bottom)
        
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        return bottom
    }
    
    //MARK: - User action
    
    @IBAction func seekerChanged(_ sender: UISlider) {
        delegate?.didInteracted(withWidget: true)
        model?.seekerUpdated(withValue: sender.value)
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

extension EZYBottomView: BottomViewUpdateUIProtocol {
    func update(currentTimeString: String) { currentTimeLabel.text = currentTimeString }
    
    func update(endTimeString: String) { endTimeLabel.text = endTimeString }
    
    func update(seekerMinValue: Float) { seeker.minimumValue = seekerMinValue }
    
    func update(seekerCurrentValue: Float) { seeker.value = seekerCurrentValue }
    
    func update(seekerMaxValue: Float) { seeker.maximumValue = seekerMaxValue }
}
