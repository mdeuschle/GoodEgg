//
//  UIImageViewExtension.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 4/4/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

typealias completion = ((Bool) -> Void)?

extension UIImageView {
    func fadeIn(completion: completion) {
        UIImageView.animate(withDuration: 1.0, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    func fadeOut(completion: completion) {
        UIImageView.animate(withDuration: 1.0, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
