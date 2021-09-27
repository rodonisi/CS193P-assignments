//
//  Cardify.swift
//  Cardify
//
//  Created by Simon Amitiel Rodoni on 26.08.21.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    var rotation: Double

    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(
                cornerRadius: DrawingConstants.cornerRadius
            )

            if rotation < 90 {
                // Base white background.
                shape
                    .fill()
                    .foregroundColor(.white)

                // Translucent color overlay
                shape
                    .fill()
                    .opacity(0.1)

                // Border
                shape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
