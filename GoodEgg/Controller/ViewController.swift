//
//  ViewController.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 3/31/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var eggImageView: UIImageView!
    @IBOutlet var shakeToSeeImageView: UIImageView!
    @IBOutlet var checkAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAgainButton.addTarget(self,
                                   action: #selector(checkAgainButtonTapped),
                                   for: .touchUpInside)
        resetGame()
    }
    
    @objc private func checkAgainButtonTapped() {
        resetGame()
    }
    
    private func resetGame() {
        checkAgainButton.alpha = 0
        checkAgainButton.isEnabled = false
        eggImageView.alpha = 0
        eggImageView.image = #imageLiteral(resourceName: "WhatKindOfEgg")
        shakeToSeeImageView.alpha = 0
        eggImageView.fadeIn { _ in
            self.shakeToSeeImageView.fadeIn { _ in }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.shakeToSeeImageView.alpha = 0
            eggImageView.image = Egg.getRadomImage()
            checkAgainButton.fadeIn { _ in
                self.checkAgainButton.isEnabled = true
            }
        }
    }
}

