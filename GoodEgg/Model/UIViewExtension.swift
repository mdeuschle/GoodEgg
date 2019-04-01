//
//  UIViewExtension.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 3/31/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

extension UIImageView {
    func fadeIn(_ duration: TimeInterval = 1.0, completion: @escaping (Bool) -> Void) {
        UIImageView.animate(withDuration: duration,
                            animations: {
                                self.alpha = 1.0
        }, completion: completion)
    }
    func fadeOut(_ duration: TimeInterval = 1.0, completion: @escaping (Bool) -> Void) {
        UIImageView.animate(withDuration: duration,
                            animations: {
                                self.alpha = 0.0
        }, completion: completion)
    }
}
