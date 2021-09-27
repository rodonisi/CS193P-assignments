//
//  EmojiArtApp.swift
//  Shared
//
//  Created by Simon Amitiel Rodoni on 28.08.21.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document:  document)
        }
    }
}
