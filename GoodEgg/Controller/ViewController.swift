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
import AudioToolbox
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var eggImageView: UIImageView!
    @IBOutlet var shakeToSeeImageView: UIImageView!
    @IBOutlet var goodEggWorldView: UIImageView!
    @IBOutlet var checkAgainButton: UIButton!
    
    private var isShakeReady = false
    private var isShaking = false
    private var timer: Timer!
    private var musicPlayer: AVAudioPlayer!
    private var shakePlayer: AVAudioPlayer!
    private var revealPlayer: AVAudioPlayer!
    private var fartPlayer: AVAudioPlayer!
    private var oopsPlayer: AVAudioPlayer!
    private var motionManager: CMMotionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCheckAgainButton()
        setupAudioPlayers()
        goodEggWorldView.rotatePlanetImage()
        startTimer()
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        motionManager = CMMotionManager()
        motionManager.startDeviceMotionUpdates(to: .main) { (deviceMotion, error) in
            guard let deviceMotion = deviceMotion else { return }
            self.motionStarted(deviceMotion: deviceMotion)
        }
    }
    
    private func motionStarted(deviceMotion: CMDeviceMotion) {
        let motionThreshold = 0.4
        let userAcceleration = deviceMotion.userAcceleration
        if fabs(userAcceleration.x) > motionThreshold
            || fabs(userAcceleration.y) > motionThreshold
            || fabs(userAcceleration.z) > motionThreshold {
            motionBegan()
        }
    }

    private func setupAudioPlayers() {
        try? musicPlayer = AVAudioPlayer(contentsOf: Audio.shared.getURL(for: .music)!)
        try? shakePlayer = AVAudioPlayer(contentsOf: Audio.shared.getURL(for: .shake)!)
        try? fartPlayer = AVAudioPlayer(contentsOf: Audio.shared.getURL(for: .fart)!)
        try? oopsPlayer = AVAudioPlayer(contentsOf: Audio.shared.getURL(for: .oops)!)
        try? revealPlayer = AVAudioPlayer(contentsOf: Audio.shared.getURL(for: .reveal)!)
        shakePlayer.delegate = self
    }
    
    private func startTimer() {
        musicPlayer.play()
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
    
    private func motionBegan() {
        if isShakeReady {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            isShakeReady = false
            shakeToSeeImageView.alpha = 0
            eggImageView.image = #imageLiteral(resourceName: "BlankEgg")
            self.isShaking = true
            shakePlayer.delegate = self
            shakePlayer.play()
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.isShaking = false
                self.shakePlayer.stop()
                self.eggImageView.fadeIn(completion: { [weak self] _ in
                    let randomNumber = Int.random(in: 0...21)
                    switch randomNumber {
                    case 17:
                        self?.oopsPlayer.play()
                    case 19:
                        self?.fartPlayer.play()
                    default:
                        self?.revealPlayer.play()
                    }
                    self?.eggImageView.image = Egg.getRadomImage(from: randomNumber)
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

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isShaking {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            player.play()
        }
    }
}

