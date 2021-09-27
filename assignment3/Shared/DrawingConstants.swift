//
//  DrawingConstants.swift
//  DrawingConstants
//
//  Created by Simon Amitiel Rodoni on 23.08.21.
//

import SwiftUI

struct DrawingConstants {
    static let cornerRadius: CGFloat = 20.0
    static let lineWidth: CGFloat = 3.0
    static let fontScale: CGFloat = 0.7
    static let cardAspectRatio: CGFloat = 2 / 3
    static let shapeAspectRatio: CGFloat =
        3 * DrawingConstants.cardAspectRatio
    static let maxAdaptiveCards: Int = 24
    static let minWidth: CGFloat = 75
}

struct GameConstants {
    static let startWith: Int = 12
    static let pickAmount: Int = 3
}
