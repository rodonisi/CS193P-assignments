//
//  Diamond.swift
//  Diamond
//
//  Created by Simon Amitiel Rodoni on 23.08.21.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let midY = rect.midY
        let midX = rect.midX

        var p = Path()
        p.move(to: CGPoint(x: midX, y: 0))
        p.addLine(to: CGPoint(x: 0, y: midY))
        p.addLine(to: CGPoint(x: midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: midY))
        p.closeSubpath()

        return p
    }

}
