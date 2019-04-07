//
//  ViewController.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 3/31/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    
    @IBOutlet var eggImageView: UIImageView!
    @IBOutlet var shakeToSeeImageView: UIImageView!
    @IBOutlet var checkAgainButton: UIButton!
    private var isShakeReady = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCheckAgainButton()
        resetGame()
    }
    
    private func configureCheckAgainButton() {
        checkAgainButton.addTarget(self,
                                   action: #selector(checkAgainButtonTapped),
                                   for: .touchUpInside)
    }
    
    @objc private func checkAgainButtonTapped() {
        resetGame()
        SKStoreReviewController.requestReview()
    }
    
    private func resetGame() {
        checkAgainButton.alpha = 0
        checkAgainButton.isEnabled = false
        eggImageView.alpha = 0
        eggImageView.image = #imageLiteral(resourceName: "WhatKindOfEgg")
        shakeToSeeImageView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: {
            self.eggImageView.fadeIn { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
                    self?.eggImageView.fadeIn { [weak self] _ in
                        self?.shakeToSeeImageView.image = #imageLiteral(resourceName: "ShakeAndSee")
                        self?.shakeToSeeImageView.fadeIn { [weak self] _ in
                            self?.isShakeReady = true
                        }
                    }
                })
            }
        })
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake, isShakeReady {
            isShakeReady = false
            shakeToSeeImageView.alpha = 0
            eggImageView.image = #imageLiteral(resourceName: "BlankEgg")
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.eggImageView.fadeIn(completion: { [weak self] _ in
                    self?.eggImageView.image = Egg.getRadomImage()
                    self?.checkAgainButton.fadeIn { [weak self] _ in
                        self?.checkAgainButton.isEnabled = true
                    }
                })
            }
            eggImageView.shake()
            CATransaction.commit()
        }
    }
}

