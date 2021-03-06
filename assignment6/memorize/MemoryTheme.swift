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
                    "ðððððððððððŧððððĶ―ðĶžðīðēðĩððšðððððĄð ðððððððððððððâïļðŦðŽðĐðšð°ððļððķâĩïļðĪðĨðģâīðĒ",
                pairs: 10,
                color: .red
            )
            addTheme(
                named: "Animals",
                emojis:
                    "ðķðąð­ðđð°ðĶðŧðžðŧââïļðĻðŊðĶðŪð·ð―ðļðĩðððððð§ðĶðĪðĢðĨðĶðĶðĶðĶðšððīðĶððŠąððĶððððŠ°ðŠēðŠģðĶðĶð·ðļðĶðĒððĶðĶðĶððĶðĶðĶðĶðĄð ððŽðģððĶððððĶðĶðĶ§ðĶĢððĶðĶðŠðŦðĶðĶðĶŽððððððððĶððĶððĐðĶŪðâðĶšððââŽðŠķððĶðĶĪðĶðĶðĶĒðĶĐðððĶðĶĻðĶĄðĶŦðĶĶðĶĨðððŋðĶðūððē",
                pairs: 21,
                color: .green
            )
            addTheme(
                named: "Sports",
                emojis: "â―ïļððâūïļðĨðūðððĨðąðŠððļðððĨððŠðĨâģïļðŠðđðĢðĪŋðĨðĨð―ðđðžð·âļðĨðŋâ·ððŠ",
                pairs: 8,
                color: .blue
            )
            addTheme(
                named: "Halloween",
                emojis: "ððŋðđðšðĪĄðĐðŧðâ ïļð―ðūðĪð",
                pairs: 6,
                color: .orange
            )
            addTheme(
                named: "Nature",
                emojis:
                    "ðĩððēðģðīðŠĩðąðŋâïļðððŠīðððððððŠĻðūðð·ðđðĨðšðļðžðŧððððððððððððððððððŠðŦâ­ïļðâĻâĄïļâïļðĨðĨðŠðâïļðĪâïļðĨâïļðĶð§âðĐðĻâïļâïļâïļðŽðĻð§ðĶâïļâïļððŦ",
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
