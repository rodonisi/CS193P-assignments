//
//  SetContent.swift
//  SetContent
//
//  Created by Simon Amitiel Rodoni on 23.08.21.
//

import Foundation

extension Equatable {
    static func allSameOrAllDifferent(a: Self, b: Self, c: Self) -> Bool {
        let allSame = a == b && b == c && a == c
        let allDifferent = a != b && b != c && a != c
        return allSame || allDifferent
    }
}

struct SetContent: SetEquatable {

    let shape: SetShape
    let count: SetCount
    let shading: SetShading
    let color: SetColor

    enum SetShape: CaseIterable {
        case diamond
        case squiggly
        case oval
    }

    enum SetCount: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }

    enum SetShading: CaseIterable {
        case solid
        case striped
        case open
    }

    enum SetColor: CaseIterable {
        case red
        case green
        case purple
    }

    static func isSet(a: SetContent, b: SetContent, c: SetContent) -> Bool {

        let shapeCondition = SetShape.allSameOrAllDifferent(
            a: a.shape,
            b: b.shape,
            c: c.shape
        )
        let countCondition = SetCount.allSameOrAllDifferent(
            a: a.count,
            b: b.count,
            c: c.count
        )
        let shadingCondition = SetShading.allSameOrAllDifferent(
            a: a.shading,
            b: b.shading,
            c: c.shading
        )
        let colorCondition = SetColor.allSameOrAllDifferent(
            a: a.color,
            b: b.color,
            c: c.color
        )

        return shapeCondition && countCondition && shadingCondition
            && colorCondition
    }
}
