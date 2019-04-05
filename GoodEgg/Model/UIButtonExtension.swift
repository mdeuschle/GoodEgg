//
//  UIButtonExtension.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 4/4/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

extension UIButton {
    func fadeIn(completion: completion) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            UIButton.animate(withDuration: 0.3, animations: {
                self.alpha = 1.0
            }, completion: completion)
        })
    }
    func fadeOut(completion: completion) {
        UIButton.animate(withDuration: 1.0, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
