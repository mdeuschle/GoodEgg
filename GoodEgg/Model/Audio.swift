//
//  Audio.swift
//  GoodEgg
//
//  Created by Matt Deuschle on 4/14/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation
import AVFoundation

struct Audio {
    static let shared = Audio()
    private init() {}
    func getResource(for style: Style) -> String {
        switch style {
        case .music:
            return "LoadMusic"
        case .shake:
            return "Shake"
        case .fart:
            return "Fart"
        case .oops:
            return "Oops"
        case .reveal:
            return "Reveal"
        }
    }
    func getPath(for style: Style) -> String? {
        let resource = getResource(for: style)
        guard let path = Bundle.main.path(forResource: resource, ofType: "mp3") else {
            return nil
        }
        return path
    }
    func getURL(for style: Style) -> URL? {
        guard let path = getPath(for: style) else { return nil }
        return URL(fileURLWithPath: path)
    }
}

enum Style {
    case music
    case shake
    case fart
    case oops
    case reveal
}

