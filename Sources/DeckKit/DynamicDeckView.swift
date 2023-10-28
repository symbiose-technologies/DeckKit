//////////////////////////////////////////////////////////////////////////////////
//
//  SYMBIOSE
//  Copyright 2023 Symbiose Technologies, Inc
//  All Rights Reserved.
//
//  NOTICE: This software is proprietary information.
//  Unauthorized use is prohibited.
//
// 
// Created by: Ryan Mckinney on 6/13/23
//
////////////////////////////////////////////////////////////////////////////////

#if os(iOS) || os(macOS)
import SwiftUI

/**
 This view renders a ``Deck`` as deck of items, from which a
 user can swipe away the top item to trigger certain actions.

 The view takes a generic ``Deck`` and maps its items to any
 views you like, which is determined by the `itemViewBuilder`.
 You can pass in a ``DeckViewConfiguration`` value to config
 how the deck should be presented.
 */
public struct DynamicDeckView<ItemType: DeckItem, ItemView: View>: View {

    /**
     Create a deck view with a standard view configuration.

     - Parameters:
       - deck: The deck to present.
       - itemView: An item view builder to use for each item in the deck.
     */
    public init(
        _ deck: Binding<Deck<ItemType>>,
        itemView: @escaping ItemViewBuilder
    ) {
        self.init(
            deck: deck,
            config: .standard,
            itemView: itemView
        )
    }

    /**
     Create a deck view with custom parameters.
     
     - Parameters:
       - deck: The deck to present.
       - config: The stacked deck configuration, by default ``DeckViewConfiguration/standard``.
       - swipeLeftAction: The action to trigger when an item is sent to the back of the deck by swiping it left, by default `nil`.
       - swipeRightAction: The action to trigger when an item is sent to the back of the deck by swiping it right, by default `nil`.
       - swipeUpAction: The action to trigger when an item is sent to the back of the deck by swiping it up, by default `nil`.
       - swipeDownAction: The action to trigger when an item is sent to the back of the deck by swiping it down, by default `nil`.
       - itemView: An item view builder to use for each item in the deck.
     */
    public init(
        deck: Binding<Deck<ItemType>>,
        config: DeckViewConfiguration = .standard,
        swipeLeftAction: ItemAction? = nil,
        swipeRightAction: ItemAction? = nil,
        swipeUpAction: ItemAction? = nil,
        swipeDownAction: ItemAction? = nil,
        itemView: @escaping ItemViewBuilder
    ) {
        self.deck = deck
        self.config = config
        self.swipeLeftAction = swipeLeftAction
        self.swipeRightAction = swipeRightAction
        self.swipeUpAction = swipeUpAction
        self.swipeDownAction = swipeDownAction
        self.itemView = itemView
        self._activeIndex = .init(wrappedValue: deck.wrappedValue.startingIdx)
    }
    
    @State var activeIndex: Int
    
    /**
     A function to trigger for a deck item swipe action.
     */
    public typealias ItemAction = (ItemType) -> Void

    /**
     A function that creates a view for a deck item.
     */
    public typealias ItemViewBuilder = (ItemType) -> ItemView
    
    private var deck: Binding<Deck<ItemType>>
    private var config: DeckViewConfiguration

    private let itemView: (ItemType) -> ItemView
    private let swipeLeftAction: ItemAction?
    private let swipeRightAction: ItemAction?
    private let swipeUpAction: ItemAction?
    private let swipeDownAction: ItemAction?

    @State
    private var activeItem: ItemType?

    @State
    private var topItemOffset: CGSize = .zero
    
    public var body: some View {
        ZStack(alignment: .center) {
            ForEach(visibleItems) { item in
                self.itemBuilder(item)
            }
        }
    }
    
    @ViewBuilder func itemBuilder(_ item: ItemType) -> some View {
        itemView(item)
            .zIndex(zIndex(of: item))
            .shadow(radius: 0.5)
            .offset(size: dragOffset(for: item))
            .scaleEffect(scale(of: item))
            .offset(y: offset(of: item))
            .rotationEffect(dragRotation(for: item) ?? .zero)
            .gesture(dragGesture(for: item))
    }
    
    
}


// MARK: - Properties

private extension DynamicDeckView {

    var items: [ItemType] {
        deck.wrappedValue.items
    }

    var visibleItems: [ItemType] {
        let first = Array(items.prefix(config.itemDisplayCount))
        return first
//        guard
//            config.alwaysShowLastItem,
//            let last = items.last,
//            !first.contains(last)
//        else { return first }
//        return Array(first).dropLast() + [last]
    }
}


// MARK: - Functions

private extension DynamicDeckView {

    /**
     Move a certain item to the back of the stack.
     */
    func moveItemToBack(_ item: ItemType) {
        deck.wrappedValue.moveToBack(item)
    }

    /**
     Move a certain item to the front of the stack.
     */
    func moveItemToFront(_ item: ItemType) {
        deck.wrappedValue.moveToFront(item)
    }
    
    func movePositionForward(from item: ItemType) {
        guard let itemIdx = self.items.firstIndex(of: item) else { return }
        if itemIdx == 0 {
            self.activeIndex = self.items.count - 1
        } else {
            self.activeIndex -= 1
        }
    
    }
    
    func movePositionBackward(from item: ItemType) {
        guard let itemIdx = self.items.firstIndex(of: item) else { return }
        if itemIdx == (self.items.count - 1) {
            self.activeIndex = 0
        } else {
            self.activeIndex += 1
        }
        
    }
}


// MARK: - View Logic

private extension DynamicDeckView {
    
    func dragGesture(for item: ItemType) -> some Gesture {
        DragGesture()
            .onChanged { dragGestureChanged($0, for: item) }
            .onEnded { dragGestureEnded($0) }
    }
    
    func dragGestureChanged(_ drag: DragGesture.Value, for item: ItemType) {
        if activeItem == nil { activeItem = item }
        if item != activeItem { return }
        topItemOffset = drag.translation
        withAnimation(.spring()) {
            if dragGestureIsPastThreshold(drag) {
                
//                moveItemToBack(item)
            } else {
                
//                moveItemToFront(item)
            }
        }
    }
    
    func dragGestureEnded(_ drag: DragGesture.Value) {
        if let item = activeItem {
            (dragGestureEndedAction(for: drag))?(item)
        }
        withAnimation(.spring()) {
            activeItem = nil
            topItemOffset = .zero
        }
    }
    
    func dragGestureEndedAction(for drag: DragGesture.Value) -> ItemAction? {
        guard dragGestureIsPastThreshold(drag) else { return nil }
        if dragGestureIsPastHorizontalThreshold(drag) {
            return drag.translation.width > 0 ? swipeRightAction : swipeLeftAction
        } else {
            return drag.translation.height > 0 ? swipeDownAction : swipeUpAction
        }
    }
    
    func dragGestureIsPastThreshold(_ drag: DragGesture.Value) -> Bool {
        dragGestureIsPastHorizontalThreshold(drag) || dragGestureIsPastVerticalThreshold(drag)
    }
    
    func dragGestureIsPastHorizontalThreshold(_ drag: DragGesture.Value) -> Bool {
        abs(drag.translation.width) > config.horizontalDragThreshold
    }
    
    func dragGestureIsPastVerticalThreshold(_ drag: DragGesture.Value) -> Bool {
        abs(drag.translation.height) > config.verticalDragThreshold
    }
    
    func dragOffset(for item: ItemType) -> CGSize {
        isActive(item) ? topItemOffset : .zero
    }
    
    func dragRotation(for item: ItemType) -> Angle? {
        guard isActive(item) else { return nil }
        return .degrees(Double(topItemOffset.width) * config.dragRotationFactor)
    }
    
    func isActive(_ item: ItemType) -> Bool {
        item == activeItem
    }

    func offset(at index: Int) -> Double {
        let offset = Double(index) * config.verticalOffset
        let multiplier: Double = config.direction == .down ? 1 : -1
        return offset * multiplier
    }
    
    func offset(of item: ItemType) -> Double {
        guard let index = visibleIndex(of: item) else { return .zero }
        return offset(at: index)
    }

    func scale(at index: Int) -> Double {
        let offset = Double(index) * config.scaleOffset
        return Double(1 - offset)
    }

    func scale(of item: ItemType) -> Double {
        guard let index = visibleIndex(of: item) else { return 1 }
        return scale(at: index)
    }

    func visibleIndex(of item: ItemType) -> Int? {
        visibleItems.firstIndex(of: item)
    }
    
    func zIndex(of item: ItemType) -> Double {
        guard let itemIndex = self.items.firstIndex(of: item) else { return 0}
        
        let itemCount = self.items.count
        
        let itemDistanceToActive = abs(itemIndex - self.activeIndex)
        
        return Double(itemCount - itemDistanceToActive)
        
    }
}


// MARK: - Private View Extensions

private extension View {
    
    func offset(size: CGSize) -> some View {
        offset(x: size.width, y: size.height)
    }
    
    func scaleEffect(_ all: CGFloat) -> some View {
        scaleEffect(x: all, y: all)
    }
}


// MARK: - Preview

struct DynamicDeckView_Previews: PreviewProvider {

    struct Preview: View {

        static var item1: PreviewCard.Item { PreviewCard.Item(
            title: "Title 1",
            text: "Text 1",
            footnote: "Footnote 1",
            backgroundColor: .blue,
            tintColor: .yellow)
        }

        static var item2: PreviewCard.Item { PreviewCard.Item(
            title: "Title 2",
            text: "Text 2",
            footnote: "Footnote 2",
            backgroundColor: .yellow,
            tintColor: .blue)
        }

        @State
        private var deck = Deck(
            name: "My Deck",
            items: [item1, item2, item1, item2, item1, item2, item1, item2, item1, item2, item1, item2,
                    item1, item2, item1, item2, item1, item2, item1, item2, item1, item2, item1, item2]
        )

        var body: some View {
            VStack {
                DeckView(deck: $deck) {
                    PreviewCard(item: $0)
                }
                DeckView(
                    deck: $deck,
                    config: .down
                ) {
                    PreviewCard(item: $0)
                }
            }
            .padding()
            .padding(.vertical, 100)
        }
    }

    static var previews: some View {
        Preview()
    }
}
#endif
