//
//  ThemeChooser.swift
//  ThemeChooser
//
//  Created by Simon Amitiel Rodoni on 08.09.21.
//

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject
    private var themeStore: ThemeStore

    @State
    private var games: [Int: EmojiMemoryGame] = [:]

    @State
    private var editMode: EditMode = .inactive

    @State
    private var themeToEdit: MemoryTheme? = nil

    var body: some View {
        NavigationView {
            List {
                if editMode == .active {
                    newThemeTile
                        .gesture(addTheme)
                }
                ForEach(themeStore.themes) { theme in
                    themeTile(for: theme)
                        .gesture(editMode == .active ? editTheme(theme) : nil)
                }
                .onDelete { indexSet in
                    themeStore.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, offset in
                    themeStore.themes.move(
                        fromOffsets: indexSet,
                        toOffset: offset
                    )
                }
            }
            .navigationTitle(DrawingConstants.navigationTitle)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
        }
        .onAppear {
            themeStore.themes.forEach { theme in
                games[theme.id] = EmojiMemoryGame(theme: theme)
            }
        }
        .onChange(of: themeStore.themes) { themes in
            themes.forEach { theme in
                games[theme.id]?.theme = theme
            }
        }
        .sheet(item: $themeToEdit) { theme in
            if let index = themeStore.themes.firstIndex(where: {
                $0.id == theme.id
            }) {
                ThemeEditor(theme: $themeStore.themes[index])
            }
        }
    }

    var newThemeTile: some View {
        HStack {
            Image(systemName: "plus")
                .frame(
                    width: DrawingConstants.cardSize,
                    height: DrawingConstants.cardSize
                )
                .clipped()
            Text("New Theme")
                .font(DrawingConstants.themeTitleFont)
            Spacer()
        }
    }

    var addTheme: some Gesture {
        TapGesture()
            .onEnded {
                themeStore.addTheme(
                    named: "New Theme",
                    emojis: "🐶🐭",
                    pairs: 2,
                    color: .red
                )
                if let theme = themeStore.themes.first {
                    games[theme.id] = EmojiMemoryGame(theme: theme)
                    themeToEdit = theme
                }
            }
    }

    @ViewBuilder
    func themeTile(for theme: MemoryTheme) -> some View {
        if let game = games[theme.id] {
            NavigationLink(
                destination: EmojiMemoryGameView()
                    .environmentObject(game)
            ) {
                HStack {
                    cardColorAndPairs(for: theme)
                    themeNameAndPreview(for: theme)
                }
            }
        }
    }

    func cardColorAndPairs(for theme: MemoryTheme) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                .foregroundColor(
                    Color(memoryColor: theme.color)
                )
                .frame(
                    width: DrawingConstants.cardSize,
                    height: DrawingConstants.cardSize
                )
            Text(String(theme.pairs))
        }
    }

    func themeNameAndPreview(for theme: MemoryTheme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .font(DrawingConstants.themeTitleFont)
            Text(
                String(
                    theme.emojis.prefix(DrawingConstants.emojisPreviewAmount)
                )
            )
        }
    }

    private func editTheme(_ theme: MemoryTheme) -> some Gesture {
        TapGesture()
            .onEnded {
                themeToEdit = theme
            }
    }

    struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let cardSize: CGFloat = 50
        static let themeTitleFont: Font = .system(size: 20, weight: .bold)
        static let emojisPreviewAmount: Int = 10
        static let navigationTitle: String = "Themes"
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser()
            .environmentObject(ThemeStore(named: "Previews"))
    }
}
