//
//  EZYMenuBuilder.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 21/11/22.
//

import UIKit


protocol EZYMenuProtocol {
    func didSelectMenu(item: String, child: String)
}

extension UIMenu {
    
    static func forTitle(_ menuTitle: String, children: [String], delegate: EZYMenuProtocol) -> UIMenu {
        var actionChildren: [UIAction] = []
        
        for child in children {
            actionChildren += [UIAction(title: child, handler: {[menuTitle, child] _ in
                delegate.didSelectMenu(item: menuTitle, child: child)
            })]
        }
        
        return UIMenu(title: menuTitle, options: children.count > 0 ? [] : .displayInline, children: actionChildren)
    }
}
