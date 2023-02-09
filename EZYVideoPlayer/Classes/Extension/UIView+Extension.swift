//
//  UIView+Extension.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 23/11/22.
//

import UIKit

extension UIView {
    static func instantiate(withOwner: Any?) -> Self {
        let nib = UINib(nibName: "\(Self.self)", bundle: Bundle(for: self))

        guard let view = nib.instantiate(withOwner: withOwner, options: nil)
            .first as? Self
        else { fatalError("failed to load \(Self.self) nib file") }

        return view
    }
}
