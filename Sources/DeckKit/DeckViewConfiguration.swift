//
//  DeckViewConfiguration.swift
//  DeckKit
//
//  Created by Daniel Saidi on 2022-11-28.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This config can be used to configure a ``DeckView``.
 */
public struct DeckViewConfiguration: Codable, Equatable {

    /**
     Create a stacked deck configuration.

     Note that `alwaysShowLastItem` will make sure that your
     deck always shows the last item, even if the deck has a
     large number of items. This makes swiping a card to the
     back look more consistent, since a card would otherwise
     fade away as it is swiped to the back of the deck.

     - Parameters:
       - direction: The visual direction of the stack, by default `.up`.
       - itemDisplayCount: The max number of items to display, by default `10`.
       - alwaysShowLastItem: Whether or not to show the last item for visual stability, by default `true`.
       - scaleOffset: The percentual shrink factor to apply to each item in the stack, by default `0.02`.
       - verticalOffset: The vertical offset to apply to each item in the stack, by default `10`.
       - dragRotationFactor: The offset factor with which to rotate an item when it's panned, by default `0.05`.
       - horizontalDragThreshold: The number of points an item must be panned to be moved to the bottom of the deck, by default `100`.
       - verticalDragThreshold: The number of points an item must be panned to be moved to the bottom of the deck, by default `250`.
     */
    public init(
        direction: Direction = .up,
        itemDisplayCount: Int = 10,
        alwaysShowLastItem: Bool = true,
        scaleOffset: Double = 0.02,
        verticalOffset: Double = 10,
        dragRotationFactor: Double = 0.05,
        horizontalDragThreshold: Double = 100,
        verticalDragThreshold: Double = 250,
        iMessageMediaStyle: Bool = false,
        dragFixedHorizontally: Bool = false
    ) {
        assert(scaleOffset > 0, "scaleOffset must be positive")
        assert(verticalOffset > 0, "verticalOffset must be positive")
        self.direction = direction
        self.itemDisplayCount = itemDisplayCount
        self.alwaysShowLastItem = alwaysShowLastItem
        self.scaleOffset = scaleOffset
        self.verticalOffset = verticalOffset
        self.dragRotationFactor = dragRotationFactor
        self.horizontalDragThreshold = horizontalDragThreshold
        self.verticalDragThreshold = verticalDragThreshold
        self.iMessageMediaStyle = iMessageMediaStyle
        self.dragFixedHorizontally = dragFixedHorizontally
    }

    /// The visual direction of the stack.
    public var direction: Direction

    /// The max number of items to display.
    public var itemDisplayCount: Int

    /// Whether or not to show the last item for visual stability.
    public var alwaysShowLastItem: Bool

    /// The percentual shrink factor to apply to each item in the stack.
    public var scaleOffset: Double

    /// The vertical offset to apply to each item in the stack.
    public var verticalOffset: Double

    /// The offset factor with which to rotate an item when it's panned.
    public var dragRotationFactor: Double

    /// The number of points an item must be panned to be moved to the bottom of the deck.
    public var horizontalDragThreshold: Double

    /// The number of points an item must be panned to be moved to the bottom of the deck.
    public var verticalDragThreshold: Double
    
    /// iMessage Horizontal Style
    public var iMessageMediaStyle: Bool
    
    /// if the drag gesture only allows for horizontal movements on a fixed axis
    public var dragFixedHorizontally: Bool
    
}

public extension DeckViewConfiguration {

    /**
     A standard deck view configuration.
     */
    static var standard = DeckViewConfiguration()

    /**
     A standard deck view configuration with down direction.
     */
    static var down = DeckViewConfiguration(
        direction: .down
    )
}

public extension DeckViewConfiguration {

    /**
     The visual direction of a stack, where ``up`` means the
     stack seems to be growing upwards, while ``down`` means
     it seems to be growing downwards.
     */
    enum Direction: String, Codable {

        case up, down
    }
}
