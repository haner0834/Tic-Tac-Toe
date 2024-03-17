//
//  AIPlayerTests.swift
//  Tic Tac ToeTests
//
//  Created by Andy Lin on 2024/3/16.
//

import XCTest
@testable import Tic_Tac_Toe

final class AIPlayerTests: XCTestCase {
    func testBasicAIPlayerMove() {
        //Given (Arrange)
        //create some test result and data
        let gameStatus: [Move?] = [nil, nil, nil, nil, nil, Move(player: .human, boardIndex: 5), nil, nil, nil]
        let AIPlayer = AIPlayer()
        
        // When(Act)
        let AIMove = AIPlayer.move(in: gameStatus)
        
        // Then(Assert)
        XCTAssertEqual(AIMove, 4)
    }
    
    func testAdd() {
        let a = 3
        let b = 4
        
        XCTAssertEqual(3 + 4, 7)
    }
}
