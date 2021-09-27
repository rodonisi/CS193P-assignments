//
//  AnimatableSystemFontModifier.swift
//  AnimatableSystemFontModifier
//
//  Created by Simon Amitiel Rodoni on 31.08.21.
//

import SwiftUI

struct AnimatableSystemFontModifier: AnimatableModifier{
    var fontSize: CGFloat
    
    var animatableData: CGFloat {
        get {
            fontSize
        }
        set {
            fontSize = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content.font(.system(size: fontSize))
    }
}

extension View {
    func animatableSystemFont(fontSize: CGFloat) -> some View {
        self.modifier(AnimatableSystemFontModifier(fontSize: fontSize))
    }
}
