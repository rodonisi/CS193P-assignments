//
//  SetApp.swift
//  Shared
//
//  Created by Simon Amitiel Rodoni on 22.08.21.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = ShapeSetGame()
    var body: some Scene {
        WindowGroup {
            ShapeSetGameView(game: game)
        }
    }
}
