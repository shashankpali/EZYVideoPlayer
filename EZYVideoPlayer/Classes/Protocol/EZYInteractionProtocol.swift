//
//  EZYInteractionProtocol.swift
//  EZYVideoPalyer
//
//  Created by Shashank Pali on 22/11/22.
//

import Foundation

internal protocol EZYInteractionProtocol {
    func didInteracted(withWidget: Bool)
    func didChangeOrientation(isLandscape: Bool)
}
