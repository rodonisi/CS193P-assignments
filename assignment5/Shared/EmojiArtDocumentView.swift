//
//  EmojiArtDocumentView.swift
//  Shared
//
//  Created by Simon Amitiel Rodoni on 28.08.21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject
    var document: EmojiArtDocument
    let defaultEmojiFontSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            documentBody
            palette
        }
    }

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(
                            convertFromEmojiCoordinates((0, 0), in: geometry)
                        )
                )
                .gesture(
                    doubleTapToZoom(in: geometry).simultaneously(
                        with: tapToClearSelection()
                    )
                )
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView()
                } else {
                    ForEach(document.emojis) { emoji in
                        selectableEmojiView(for: emoji, in: geometry)
                    }
                }
            }
            .clipped()
            .onDrop(of: [.plainText, .url, .image], isTargeted: nil) {
                providers,
                location in
                return drop(
                    providers: providers,
                    at: location,
                    in: geometry
                )
            }
            .gesture(panGesture().simultaneously(with: zoomGesture()))
        }
    }

    private func emojiView(for emoji: EmojiArtModel.Emoji) -> some View {
        Text(emoji.text)
            .animatableSystemFont(fontSize: fontSize(for: emoji))
            .onTapGesture {
                withAnimation {
                    toggleSelection(for: emoji)
                }
            }
    }

    @ViewBuilder
    private func selectableEmojiView(
        for emoji: EmojiArtModel.Emoji,
        in geometry: GeometryProxy
    ) -> some View {
        let size = fontSize(for: emoji)
        ZStack {
            emojiView(for: emoji)
            if selectedEmojis.contains(emoji.id) {
                Rectangle()
                    .strokeBorder()
                    .foregroundColor(
                        DrawingConstants.selectionColor
                    )
                    .frame(
                        width: size
                            * DrawingConstants
                            .selectionScale,
                        height: size
                            * DrawingConstants
                            .selectionScale
                    )
                    .transition(.scale)
            }
        }
        .position(position(for: emoji, in: geometry))
        .gesture(emojiPanGesture(for: emoji))
    }

    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size) * zoomScale
    }

    private func position(
        for emoji: EmojiArtModel.Emoji,
        in geometry: GeometryProxy
    ) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }

    private func convertFromEmojiCoordinates(
        _ location: (x: Int, y: Int),
        in geometry: GeometryProxy
    ) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }

    private func convertToEmojiCoordinates(
        _ location: CGPoint,
        in geometry: GeometryProxy
    ) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (location.x - panOffset.width - center.x) / zoomScale,
            y: (location.y - panOffset.height - center.y) / zoomScale
        )
        return (Int(location.x), Int(location.y))
    }

    private func drop(
        providers: [NSItemProvider],
        at location: CGPoint,
        in geometry: GeometryProxy
    ) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            document.setBackgrount(EmojiArtModel.Background.url(url.imageURL))
        }
        if !found {
            found = providers.loadObjects(ofType: UIImage.self) { image in
                if let data = image.jpegData(compressionQuality: 1.0) {
                    document.setBackgrount(.imageData(data))
                }
            }
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                if let emoji = string.first, emoji.isEmoji {
                    document.addEmoji(
                        String(emoji),
                        at: convertToEmojiCoordinates(location, in: geometry),
                        size: defaultEmojiFontSize / zoomScale
                    )

                }
            }
        }
        return found
    }

    @State
    private var steadyStateZoomScale: CGFloat = 1.0

    @GestureState
    private var gestureZoomScale: CGFloat = 1

    private var zoomScale: CGFloat {
        steadyStateZoomScale * (selectedEmojis.isEmpty ? gestureZoomScale : 1)
    }

    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0,
            size.width > 0, size.height > 0
        {
            let hZoom = size.width / image.size.width
            let vZoom = size.width / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) {
                latestGestureScale,
                gestureZoomScale,
                transaction in
                if !selectedEmojis.isEmpty {
                    let scaleSinceLastUpdate =
                        latestGestureScale / gestureZoomScale
                    scaleSelectedEmojis(by: scaleSinceLastUpdate)
                }
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScale in
                if selectedEmojis.isEmpty {
                    steadyStateZoomScale *= gestureScale
                }
            }
    }

    @State
    private var steadyStatePanOffset: CGSize = CGSize.zero

    @GestureState
    private var gesturePanOffset: CGSize = CGSize.zero

    var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }

    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) {
                latestDragGestureValue,
                gestureZoomPanOffset,
                _ in
                gestureZoomPanOffset =
                    latestDragGestureValue.translation / zoomScale
            }
            .onEnded { dragValue in
                steadyStatePanOffset =
                    steadyStatePanOffset + (dragValue.translation / zoomScale)
            }
    }

    @GestureState
    private var gestureEmojiPanOffset: CGSize = CGSize.zero

    private func emojiPanGesture(for emoji: EmojiArtModel.Emoji) -> some Gesture
    {
        DragGesture()
            .updating($gestureEmojiPanOffset) {
                latestDragGestureValue,
                gestureEmojiPanOffset,
                _ in
                let scaledDragValue =
                    latestDragGestureValue.translation / zoomScale
                let lastUpdateOffset =
                    (scaledDragValue - gestureEmojiPanOffset)
                if selectedEmojis.isEmpty || !selectedEmojis.contains(emoji.id)
                {
                    document.moveEmoji(emoji, by: lastUpdateOffset)
                } else {
                    moveSelectedEmojis(by: lastUpdateOffset)
                }
                gestureEmojiPanOffset = scaledDragValue
            }
    }

    private func doubleTapToZoom(in geometry: GeometryProxy) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: geometry.size)
                }
            }
    }

    private func tapToClearSelection() -> some Gesture {
        TapGesture()
            .onEnded {
                withAnimation {
                    clearSelection()
                }
            }
    }

    @State
    private var selectedEmojis: Set<Int> = []

    private func toggleSelection(for emoji: EmojiArtModel.Emoji) {
        let id = emoji.id
        if selectedEmojis.contains(id) {
            selectedEmojis.remove(id)
        } else {
            selectedEmojis.insert(id)
        }
    }

    private func clearSelection() {
        selectedEmojis.removeAll()
    }

    private func moveSelectedEmojis(by offset: CGSize) {
        selectedEmojis.forEach { id in
            if let index = document.emojis.firstIndex(where: { $0.id == id }) {
                document.moveEmoji(document.emojis[index], by: offset)
            }
        }
    }

    private func scaleSelectedEmojis(by offset: CGFloat) {
        selectedEmojis.forEach { id in
            if let index = document.emojis.firstIndex(where: {
                $0.id == id
            }) {
                document.scaleEmoji(
                    document.emojis[index],
                    by: offset
                )
            }
        }
    }

    private func deleteSelectedEmojis() {
        selectedEmojis.forEach { id in
            if let index = document.emojis.firstIndex(where: { $0.id == id }) {
                document.removeEmoji(at: index)
            }
        }
        withAnimation {
            clearSelection()
        }
    }

    var palette: some View {
        ScrollingEmojisView(
            emojis: testEmojis,
            showDeleteButton: !selectedEmojis.isEmpty,
            deleteAction: deleteSelectedEmojis
        )
        .font(.system(size: defaultEmojiFontSize))
    }

    let testEmojis = "😀😬😁😂😃😄😅😆😇😉😊🙂🙃😋😌😍😘😗😙😚😜😝😛🤑🤓😎🤗😏😶😐😑😒🙄"

    struct DrawingConstants {
        static let selectionScale: CGFloat = 1.5
        static let selectionColor: Color = .red
    }
}

struct ScrollingEmojisView: View {
    let emojis: String
    var showDeleteButton: Bool
    var deleteAction: () -> Void

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if showDeleteButton {
                    Button(
                        action: deleteAction,
                        label: { Image(systemName: "trash") }
                    )
                    .foregroundColor(.red)
                }
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag {
                            NSItemProvider(object: emoji as NSString)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        EmojiArtDocumentView(document: EmojiArtDocument())
    }
}
