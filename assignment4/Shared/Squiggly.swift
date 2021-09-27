//
//  Squiggly.swift
//  Squiggly
//
//  Created by Simon Amitiel Rodoni on 23.08.21.
//

import SwiftUI

struct Squiggly: Shape {
    func path(in rect: CGRect) -> Path {
        let thirdX: CGFloat = rect.maxX / 3
        let thirdY: CGFloat = rect.maxY / 3

        var p = Path()
        p.move(to: CGPoint(x: 0, y: thirdY))
        p.addCurve(
            to: CGPoint(x: rect.maxX, y: 0),
            control1: CGPoint(x: thirdX, y: 0),
            control2: CGPoint(x: 2 * thirdX, y: thirdY)
        )
        p.addLine(to: CGPoint(x: rect.maxX, y: 2 * thirdY))
        p.addCurve(
            to: CGPoint(x: 0, y: rect.maxY),
            control1: CGPoint(x: 2 * thirdX, y: rect.maxY),
            control2: CGPoint(x: thirdX, y: 2 * thirdY)
        )
        p.closeSubpath()

        return p
    }
}

struct Squiggly_Previews: PreviewProvider {
    static var previews: some View {
        Squiggly().frame(width: 180*2, height: 180)
    }
}
