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
        UIImageView.animate(withDuration: 0.4, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    func fadeOut(completion: completion) {
        UIImageView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = Float.random(in: 10..<30)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 21,
                                                       y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 18,
                                                     y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}


