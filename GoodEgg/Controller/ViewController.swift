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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCheckAgainButton()
        setupAudioPlayers()
        goodEggWorldView.rotatePlanetImage()
        startTimer()
    }
    
    private func setupAudioPlayers() {
        guard let musicPath = Bundle.main.path(forResource: "LoadMusic",
                                               ofType: "mp3"),
            let shakePath = Bundle.main.path(forResource: "Shake",
                                             ofType: "mp3"),
            let fartPath = Bundle.main.path(forResource: "Fart",
                                            ofType: "mp3"),
            let oopsPath = Bundle.main.path(forResource: "Oops",
                                            ofType: "mp3"),
            let revealPath = Bundle.main.path(forResource: "Reveal",
                                              ofType: "mp3") else { return }
        let musicURL = URL(fileURLWithPath: musicPath)
        try? musicPlayer = AVAudioPlayer(contentsOf: musicURL)
        let shakeURL = URL(fileURLWithPath: shakePath)
        try? shakePlayer = AVAudioPlayer(contentsOf: shakeURL)
        let fartURL = URL(fileURLWithPath: fartPath)
        try? fartPlayer = AVAudioPlayer(contentsOf: fartURL)
        let oopsURL = URL(fileURLWithPath: oopsPath)
        try? oopsPlayer = AVAudioPlayer(contentsOf: oopsURL)
        let revealURL = URL(fileURLWithPath: revealPath)
        try? revealPlayer = AVAudioPlayer(contentsOf: revealURL)
        musicPlayer.prepareToPlay()
        shakePlayer.prepareToPlay()
        fartPlayer.prepareToPlay()
        oopsPlayer.prepareToPlay()
        revealPlayer.prepareToPlay()
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
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake, isShakeReady {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            isShakeReady = false
            shakeToSeeImageView.alpha = 0
            eggImageView.image = #imageLiteral(resourceName: "BlankEgg")
            self.isShaking = true
            self.shakePlayer.play()
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

