//
//  memorizeApp.swift
//  memorize
//
//  Created by Simon Amitiel Rodoni on 16.08.21.
//

import SwiftUI

@main
struct memorizeApp: App {
    @StateObject
    var themeStore = ThemeStore(named: "Default")

    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
