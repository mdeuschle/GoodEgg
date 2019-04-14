//
//  Egg.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 3/31/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

struct Egg {
    static func getRadomImage(from randomNumber: Int) -> UIImage? {
        guard let randomImage = UIImage(named: String(randomNumber)) else {
            return nil
        }
        return randomImage
    }
}



