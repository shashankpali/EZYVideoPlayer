//
//  EZYTopView.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 16/11/22.
//

import UIKit

internal protocol EZYTopViewProtocol {
    var delegate: EZYInteractionProtocol? { get set }
    
    static func setup(on view: UIView, withTitle: String?) -> EZYTopViewProtocol
    func observeOrientation()
}

internal final class EZYTopView: UIView, EZYTopViewProtocol {
    
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    //
    weak var delegate: EZYInteractionProtocol?
    var isLandscape = false
    
    static func setup(on view: UIView, withTitle: String?) -> EZYTopViewProtocol {
        
        let topView = EZYTopView.instantiate(withOwner: nil)
        view.addSubview(topView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        topView.titleLabel.text = withTitle
        
        return topView
    }
    
    //MARK: - User actions
    
    func observeOrientation() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        UIDevice.current.orientation.isLandscape ? updateBtnImage(forLandscape: true) : updateBtnImage(forLandscape: false)
    }
    
    @IBAction func expandBtnTapped(_ sender: UIButton) {
        
        delegate?.didInteracted(withWidget: true)
        
        updateBtnImage(forLandscape: !isLandscape)
        
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: isLandscape ? .landscape : .portrait))
        } else {
            let o = isLandscape ? UIInterfaceOrientation.landscapeRight : UIInterfaceOrientation.portrait
            UIDevice.current.setValue(Int(o.rawValue), forKey: "orientation")
        }
    }
    
    // MARK: - Helper
    
    func updateBtnImage(forLandscape: Bool) {
        isLandscape = forLandscape
        delegate?.didChangeOrientation(isLandscape: isLandscape)
        let img = isLandscape ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right"
        expandBtn.setImage(UIImage(systemName: img), for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}
