//
//  StackedDeckConfigurationTests.swift
//  DeckKit
//
//  Created by Daniel Saidi on 2022-11-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import DeckKit
import XCTest

final class StackedDeckConfigurationTests: XCTestCase {

    func testStandardInstanceUsesStandardValues() {
        let config = StackedDeckConfiguration.standard
        XCTAssertEqual(config.direction, .up)
        XCTAssertEqual(config.cardDisplayCount, 10)
        XCTAssertEqual(config.alwaysShowLastCard, true)
        XCTAssertEqual(config.scaleOffset, 0.02)
        XCTAssertEqual(config.verticalOffset, 10)
        XCTAssertEqual(config.horizontalDragThreshold, 100)
        XCTAssertEqual(config.verticalDragThreshold, 250)
    }

    func testCustomInstanceUsesCustomValues() {
        let config = StackedDeckConfiguration(
            direction: .down,
            cardDisplayCount: 20,
            alwaysShowLastCard: false,
            scaleOffset: 0.01,
            verticalOffset: 20,
            horizontalDragThreshold: 123,
            verticalDragThreshold: 456
        )
        XCTAssertEqual(config.direction, .down)
        XCTAssertEqual(config.cardDisplayCount, 20)
        XCTAssertEqual(config.alwaysShowLastCard, false)
        XCTAssertEqual(config.scaleOffset, 0.01)
        XCTAssertEqual(config.verticalOffset, 20)
        XCTAssertEqual(config.horizontalDragThreshold, 123)
        XCTAssertEqual(config.verticalDragThreshold, 456)
    }
}