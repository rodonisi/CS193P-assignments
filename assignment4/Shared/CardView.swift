//
//  CardView.swift
//  CardView
//
//  Created by Simon Amitiel Rodoni on 23.08.21.
//

import SwiftUI

extension Shape {
    @ViewBuilder
    fileprivate func applyShading(_ shading: SetContent.SetShading) -> some View
    {
        switch shading {
        case .striped:
            ZStack {
                self.fill().opacity(0.5)
                self.stroke(lineWidth: 3)
            }
        case .solid:
            self.fill()
        case .open:
            self.stroke(lineWidth: 3)
        }
    }
}

struct CardView: View {
    var card: ShapeSetGame.Card
    var isMatch: Bool?
    var flip: Bool = false

    @State
    private var faceUp: Bool = true

    var cardColor: Color {
        if card.isSelected {
            if isMatch != nil {
                if isMatch! { return .green }
                return .red
            }
            return .yellow
        }

        return .blue
    }

    var body: some View {
        if flip {
            cardBody
                .onAppear {
                    faceUp = false
                    withAnimation {
                        faceUp = true
                    }
                }
        } else {
            cardBody
        }
    }

    var cardBody: some View {
        VStack {
            ForEach((1...card.content.count.rawValue), id: \.self) {
                index in
                shape
                    .zIndex(Double(index))
                    .aspectRatio(2 / 1, contentMode: .fit)
                    .rotationEffect(
                        Angle.degrees(
                            (isMatch ?? false) && card.isSelected ? 360 : 0
                        )
                    )
            }
        }
        .foregroundColor(color)
        .padding()
        .opacity(!(isMatch ?? true) && card.isSelected ? 0.5 : 1.0)
        .scaleEffect(!(isMatch ?? true) && card.isSelected ? 0.8 : 1.0)
        .cardify(isFaceUp: card.state != .undealt && faceUp)
        .foregroundColor(cardColor)
    }

    private func font(in size: CGSize) -> Font {
        Font.system(
            size: min(size.width, size.height)
                * DrawingConstants.fontScale
        )
    }

    @ViewBuilder
    var shape: some View {
        let shading = card.content.shading
        switch card.content.shape {
        case .oval:
            RoundedRectangle(cornerRadius: 25).applyShading(shading)
        case .diamond:
            Diamond().applyShading(shading)
        case .squiggly:
            Squiggly().applyShading(shading)
        }
    }

    var color: Color {
        switch card.content.color {
        case .green:
            return .green
        case .purple:
            return .purple
        case .red: return .red
        }

    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = ShapeSetGame.Card(
            id: 0,
            content: SetContent(
                shape: .squiggly,
                count: .three,
                shading: .open,
                color: .red
            )
        )
        CardView(card: card)
    }
}
