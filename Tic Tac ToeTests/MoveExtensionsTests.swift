//
//  MoveExtensionsTests.swift
//  Tic Tac ToeTests
//
//  Created by Andy Lin on 2024/3/16.
//

import XCTest
@testable import Tic_Tac_Toe

final class MoveExtensionsTests: XCTestCase {
    func testIsNearBy3() {
        let move = Move(player: .computer, boardIndex: 3)
        let index = 4
        
        let isNearBy4 = move.isNearBy(4, length: 3)
        
        XCTAssertTrue(isNearBy4)
    }
}
