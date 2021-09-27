//
//  memorizeApp.swift
//  memorize
//
//  Created by Simon Amitiel Rodoni on 16.08.21.
//

import SwiftUI

@main
struct memorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
