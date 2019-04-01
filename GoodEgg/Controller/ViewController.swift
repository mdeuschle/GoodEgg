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
        shakeToSeeImageView.isHidden = true
        checkAgainButton.addTarget(self,
                                   action: #selector(checkAgainButtonTapped),
                                   for: .touchUpInside)
    }
    
    @objc private func checkAgainButtonTapped() {
        eggImageView.image = Egg.getRadomImage()
    }
}

