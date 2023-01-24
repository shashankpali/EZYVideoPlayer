//
//  EZYMenuBuilder.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import UIKit

extension UIMenu {
        
    static func forTitle(_ menuTitle: String, children: [PlayerMenu], delegate: EZYMenuDelegate) -> UIMenu {
        
        let actionChildren = children.map { child in
            UIAction(title: "\(child.rawValue)".capitalized, handler: {[child, weak delegate] _ in
                delegate?.didSelect(item: child)
            })
        }
        
        let opts : UIMenu.Options
        if #available(iOS 15.0, *) { opts = .singleSelection } else { opts = .displayInline }
        return UIMenu(title: menuTitle, options: opts, children: actionChildren)
    }
}
