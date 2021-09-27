//
//  MemoryTheme.swift
//  MemoryTheme
//
//  Created by Simon Amitiel Rodoni on 07.09.21.
//

import Foundation

class ThemeStore: ObservableObject {
    var name: String

    @Published
    var themes = [MemoryTheme]() {
        didSet {
            storeInUserDefaults()
        }
    }

    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            addTheme(
                named: "Vehicles",
                emojis:
                    "🚗🚕🚙🚌🚎🏎🚓🚑🚒🚐🛻🚚🚛🚜🦽🦼🛴🚲🛵🏍🛺🚔🚍🚘🚖🚡🚠🚟🚃🚋🚞🚝🚄🚅🚈🚂🚆🚇🚊🚉✈️🛫🛬🛩💺🛰🚀🛸🚁🛶⛵️🚤🛥🛳⛴🚢",
                pairs: 10,
                color: .red
            )
            addTheme(
                named: "Animals",
                emojis:
                    "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🙈🙉🙊🐒🐔🐧🐦🐤🐣🐥🦆🦅🦉🦇🐺🐗🐴🦄🐝🪱🐛🦋🐌🐞🐜🪰🪲🪳🦟🦗🕷🕸🦂🐢🐍🦎🦖🦕🐙🦑🦐🦞🦀🐡🐠🐟🐬🐳🐋🦈🐊🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🐂🐄🐎🐖🐏🐑🦙🐐🦌🐕🐩🦮🐕‍🦺🐈🐈‍⬛🪶🐓🦃🦤🦚🦜🦢🦩🕊🐇🦝🦨🦡🦫🦦🦥🐁🐀🐿🦔🐾🐉🐲",
                pairs: 21,
                color: .green
            )
            addTheme(
                named: "Sports",
                emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🪀🏓🏸🏒🏑🥍🏏🪃🥅⛳️🪁🏹🎣🤿🥊🥋🎽🛹🛼🛷⛸🥌🎿⛷🏂🪂",
                pairs: 8,
                color: .blue
            )
            addTheme(
                named: "Halloween",
                emojis: "😈👿👹👺🤡💩👻💀☠️👽👾🤖🎃",
                pairs: 6,
                color: .orange
            )
            addTheme(
                named: "Nature",
                emojis:
                    "🌵🎄🌲🌳🌴🪵🌱🌿☘️🍀🎍🪴🎋🍃🍂🍁🍄🐚🪨🌾💐🌷🌹🥀🌺🌸🌼🌻🌞🌝🌛🌜🌚🌕🌖🌗🌘🌑🌒🌓🌔🌙🌎🌍🌏🪐💫⭐️🌟✨⚡️☄️💥🔥🌪🌈☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️☃️⛄️🌬💨💧💦☔️☂️🌊🌫",
                pairs: 12,
                color: .purple
            )
        }
    }

    // MARK: - Privates

    private var userDefaultsKey: String {
        "ThemeStore" + name
    }

    private func storeInUserDefaults() {
        UserDefaults.standard.set(
            try? JSONEncoder().encode(themes),
            forKey: userDefaultsKey
        )
    }

    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
            let decoded = try? JSONDecoder().decode(
                [MemoryTheme].self,
                from: jsonData
            )
        {
            themes = decoded
        }
    }

    // MARK: - Intents

    func theme(at index: Int) -> MemoryTheme {
        themes[index]
    }

    func addTheme(
        named name: String,
        emojis: String,
        pairs: Int,
        color: MemoryTheme.MemoryColor
    ) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme =
            MemoryTheme(
                name: name,
                emojis: emojis,
                color: color,
                pairs: pairs,
                id: unique
            )

        themes.insert(theme, at: themes.startIndex)
        print("added theme")
        print(theme)
    }

    func removeTheme(at index: Int) {
        themes.remove(at: index)
    }
}

struct MemoryTheme: Codable, Identifiable, Equatable {
    var name: String
    var emojis: String {
        willSet {
            let removed = emojis.filter { emoji in
                !newValue.contains(emoji)
            }
            removedEmojis += removed
            removedEmojis.removeAll {
                emoji in newValue.contains(emoji)
            }
        }
        didSet {
            emojis = emojis.removingDuplicateCharacters.filter({ $0.isEmoji })
        }
    }
    var removedEmojis: String = ""
    var color: MemoryColor
    var pairs: Int
    let id: Int

    struct MemoryColor: Codable, Equatable {
        static let red: MemoryColor = MemoryColor(
            red: 1.0,
            green: 0.0,
            blue: 0.0
        )
        static let green: MemoryColor = MemoryColor(
            red: 0.0,
            green: 1.0,
            blue: 0.0
        )
        static let blue: MemoryColor = MemoryColor(
            red: 0.0,
            green: 0.0,
            blue: 1.0
        )
        static let orange: MemoryColor = MemoryColor(
            red: 1.0,
            green: 0.5,
            blue: 0.0
        )
        static let purple: MemoryColor = MemoryColor(
            red: 0.5,
            green: 0.0,
            blue: 1.0
        )
        static let pink: MemoryColor = MemoryColor(
            red: 1.0,
            green: 0.0,
            blue: 1.0
        )

        let red: Double, green: Double, blue: Double, alpha: Double

        init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
    }
}
