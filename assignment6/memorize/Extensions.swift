//
//  Extensions.swift
//  Extensions
//
//  Created by Simon Amitiel Rodoni on 07.09.21.
//

import SwiftUI

extension Color {
    init(memoryColor: MemoryTheme.MemoryColor) {
        self.init(
            .sRGB,
            red: memoryColor.red,
            green: memoryColor.green,
            blue: memoryColor.blue,
            opacity: memoryColor.alpha
        )
    }
}

extension MemoryTheme.MemoryColor {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if let cgColor = color.cgColor {
            UIColor(cgColor: cgColor).getRed(
                &red,
                green: &green,
                blue: &blue,
                alpha: &alpha
            )
        }
        self.init(
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            alpha: Double(alpha)
        )
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 { return first } else { return nil }
    }
}

extension Character {
    var isEmoji: Bool {
        // Swift does not have a way to ask if a Character isEmoji
        // but it does let us check to see if our component scalars isEmoji
        // unfortunately unicode allows certain scalars (like 1)
        // to be modified by another scalar to become emoji (e.g. 1️⃣)
        // so the scalar "1" will report isEmoji = true
        // so we can't just check to see if the first scalar isEmoji
        // the quick and dirty here is to see if the scalar is at least the first true emoji we know of
        // (the start of the "miscellaneous items" section)
        // or check to see if this is a multiple scalar unicode sequence
        // (e.g. a 1 with a unicode modifier to force it to be presented as emoji 1️⃣)
        if let firstScalar = unicodeScalars.first,
            firstScalar.properties.isEmoji
        {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}

extension String {
    var removingDuplicateCharacters: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}
