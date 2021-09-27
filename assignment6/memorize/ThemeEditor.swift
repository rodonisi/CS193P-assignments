//
//  ThemeEditor.swift
//  ThemeEditor
//
//  Created by Simon Amitiel Rodoni on 09.09.21.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding
    var theme: MemoryTheme

    @Environment(\.presentationMode)
    private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                nameSection
                addEmojisSection
                removeEmojisSection
                removedEmojisSection
                pairsSection
                colorSection
            }
            .navigationTitle(Text("Edit \(theme.name)"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    private var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $theme.name)
        }
    }

    @State
    private var emojisToAdd = ""
    private var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd, perform: addEmojis)
        }
    }
    private func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis += emojis
        }
    }

    private func emojiGrid(
        for emojis: String,
        action: @escaping (String) -> AnyGesture<Any>
    ) -> some View {
        let emojisArray = theme.emojis.map { String($0) }
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
            ForEach(emojisArray, id: \.self) { emoji in
                Text(emoji)
                    .gesture(action(emoji))
            }
        }
        .font(.system(size: 40))
    }

    private var removeEmojisSection: some View {
        Section(header: Text("Remove Emojis")) {
            let emojis = theme.emojis.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .gesture(
                            theme.emojis.count > 2 ? removeEmoji(emoji) : nil
                        )
                }
            }
            .font(.system(size: 40))
        }
    }

    private func removeEmoji(_ emoji: String) -> some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    theme.emojis.removeAll(where: {
                        String($0) == emoji
                    })
                }
            }
    }

    private var removedEmojisSection: some View {
        Section(header: Text("Add Back Emojis")) {
            let emojis = theme.removedEmojis.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            addEmojis(emoji)
                        }
                }
            }
            .font(.system(size: 40))
        }
    }

    private var pairsSection: some View {
        Section(header: Text("Pairs")) {
            Stepper(
                String(theme.pairs),
                value: $theme.pairs,
                in: 2...theme.emojis.count,
                step: 1
            )
        }
    }

    private var colorSection: some View {
        let binding = Binding<Color>(
            get: {
                Color(memoryColor: theme.color)
            },
            set: { color in
                theme.color = MemoryTheme.MemoryColor(color: color)
            }
        )
        return Section {
            ColorPicker("Color", selection: binding)
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(
            theme: .constant(
                MemoryTheme(
                    name: "Preview",
                    emojis: "⚽️🏀🏈⚾️🥎🎾🏐🏉🥏🎱🪀🏓",
                    color: MemoryTheme.MemoryColor(red: 0, green: 0, blue: 0),
                    pairs: 0,
                    id: 0
                )
            )
        )
    }
}
