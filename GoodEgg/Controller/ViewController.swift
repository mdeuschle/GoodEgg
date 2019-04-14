//
//  ViewController.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 3/31/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit
import StoreKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var eggImageView: UIImageView!
    @IBOutlet var shakeToSeeImageView: UIImageView!
    @IBOutlet var goodEggWorldView: UIImageView!
    @IBOutlet var checkAgainButton: UIButton!
    private var isShakeReady = false
    private var timer: Timer!
    private var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCheckAgainButton()
        goodEggWorldView.rotatePlanetImage()
        goodEggMusic()
        startTimer()
    }
    
    private func goodEggMusic() {
        guard let resourcePath = Bundle.main.path(forResource: "LoadMusic",
                                                  ofType: "mp3") else {
                                                    return
        }
        let url = URL(fileURLWithPath: resourcePath)
        try? musicPlayer = AVAudioPlayer(contentsOf: url)
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0,
                                     repeats: false,
                                     block: { [weak self] _ in
                                        self?.goodEggWorldView.isHidden = true
                                        self?.musicPlayer.stop()
                                        self?.resetGame()
        })
    }
    
    private func configureCheckAgainButton() {
        checkAgainButton.alpha = 0
        checkAgainButton.isEnabled = false
        checkAgainButton.addTarget(self,
                                   action: #selector(checkAgainButtonTapped),
                                   for: .touchUpInside)
    }
    
    @objc private func launchGoodEggWorld() {
        goodEggWorldView.rotatePlanetImage()
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

