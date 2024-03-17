//
//  AIPlayer.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2024/3/5.
//

import Foundation

class AIPlayer {
    /// - Returns: return `AIPlayer()` object to let `AIPlayer` initialing more readable
    static var main: AIPlayer {
        return AIPlayer()
    }
    
    /// - Returns: The answer of AI with the pattern below
    ///
    ///## These is pattern of how AI gives answer:
    ///if AI can win, then win.
    ///
    ///if AI can't win, then block.
    ///
    ///if AI can't block, then take the middle square.
    ///
    ///if AI can't take the middle square, then take random square.
    ///
    ///You can use this function to decide the number that AI computer player's position on Tic Tac Toe game,
    ///for example:
    ///```swift
    ///let position = AIPlayer.main.move(in: moves)
    ///let AIMoves = Move(player: .computer, boardIndex: position)
    ///```
    func move(in moves: [Move?]) -> Int {
        let checker = MoveChecker()
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter { $0.player == .computer }
        // .compactMap: remove nil in Set, and filter is used to find the $0.player equals .computer in the Set
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            /* .subtracting(_: Set<Element>): check Set and the input Set, and only return the value that pravious Set has and the input Set doesn't
             for example, if there's two Set,
             let kkk: Set = [2, 5, 3, 7, 9]
             let jjj: Set = [1, 2, 3, 4, 5]
             and
             kkk.subtracting(jjj) will return [7, 9]
             */
            
            ///winPosition.count equals 1 means the number(position) u found is the position that can let AI win
            if winPositions.count == 1 {
                let isAvailable = !checker.isSquareOccupied(in: moves, forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter { $0.player == .human }
        let humanPosition = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            ///winPosition.count equals 1 means this position is the position that human can win after select this
            if winPositions.count == 1 {
                let isAvailable = !checker.isSquareOccupied(in: moves, forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If AI can't block, then take middle square
        let middleSquare = 4
        if !checker.isSquareOccupied(in: moves, forIndex: middleSquare){ return middleSquare }
        
        // If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while checker.isSquareOccupied(in: moves, forIndex: movePosition) {
            //didn't need add "self." is bcuz the moves is equals self.moves( self.moves will enter the function)
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    /// - Returns: This is the AI computer's answer of tic tac toe game
    /// - Parameter moves: The game status
    ///
    ///## Overview
    /// Check all the square AI can move to, and give each square a score, then return the item count of the square with highest score
    ///
    /// Create a variable `scores` to record the score of each square
    ///
    /// And travers the entire array of input(`moves: [Move?]`), skip the square which was occupied.
    ///
    /// When the function traversing the `moves`, means we expect AI move to this square, and retraver the array that added we expect AI move, to find the highest score
    ///
    ///## These are rule of scoring square:
    /// - if this move can create an oppertunity to win: +2
    /// - if this move can block human: +1
    ///
    ///_THESE RULE IS ABOUT THE SECOND TRAVERSING THE ARRAY OF INPUT AFTER ADDING THE SQUARE WE EXPECT AI MOVE TO_
    ///
    ///## These are rule of first traversing input:
    /// - if this move can win directly: +4
    /// - if this move can block human: +2
    ///
    ///_These also scoring the square and not return square directly_
    ///
    /// And after scoring all the square, I gave each square a weight
    ///
    /// ## These are the weight of each square:
    /// - The square on the corner: 0.7
    /// - The middle square: 1.0
    /// - The square on the side of board and not on the corner: 0.65
    ///
    /// And mutiply each score by their weight, find the highest score and return it
    ///
    /// If there's more than one highest score(same high score), return random of it
    ///
    /// - Complexity: O(n^2 + 3n), when n is length of array
    func smarterMove(in moves: [Move?]) -> Int {
        let checker = MoveChecker()
        var scores = Array(repeating: 0.0, count: moves.count)
        let weighteds = [0.7, 0.65, 0.7, 0.65, 1, 0.65, 0.7, 0.65, 0.7]
        
        for i in 0..<moves.count {
            let isSquareOccupied = checker.isSquareOccupied(in: moves, forIndex: i)
            if !isSquareOccupied {
                //we expect AI move to this square
                var expectMove = moves
                
                expectMove[i] = Move(player: .computer, boardIndex: i)
                if checker.checkWin(in: expectMove, for: .computer) {
                    scores[i] += 4
                }
                
                expectMove[i] = Move(player: .human, boardIndex: i)
                if checker.checkWin(in: expectMove, for: .human) {
                    scores[i] += 2
                }
                //reset the expect of AI moves, player is .computer instead .human
                expectMove[i] = Move(player: .computer, boardIndex: i)
                
                //traversing the array that added the square we expect AI move to
                for j in 0..<expectMove.count {
                    let isSquareOccupied = checker.isSquareOccupied(in: expectMove, forIndex: j)
                    if !isSquareOccupied {
                        var expect = expectMove
                        
                        //check whether AI can win in this move
                        expect[i] = Move(player: .computer, boardIndex: i)
                        expect[j] = Move(player: .computer, boardIndex: j)
                        if checker.checkWin(in: expect, for: .computer) {
                            let weighted = weighteds[i]
                            scores[i] += 2 * weighted
                            print("this move will create an opportunity of computer, so score of the square is \(scores[i])(in\(i), \(j))")
                        }
                        
                        //check human can win in this move
                        expect[i] = Move(player: .human, boardIndex: i)
                        expect[j] = Move(player: .human, boardIndex: j)
                        if checker.checkWin(in: expect, for: .human) {
                            let weighted = weighteds[i]
                            scores[i] += 1 * weighted
                            print("this move probably block human, so score of the square is \(scores[i])(in\(i), \(j))")
                        }
                    }
                }
            }
        }
        //if the middle square hasn't be occupied, return it
        print("scores : \(scores)")
//        if !checker.isSquareOccupied(in: moves, forIndex: 4) {
//            print("bcuz middle square aren't occupied")
//            return 4
//        }
        
        //get highest score we just scored of each square
        var max = scores[0]
        var count = 0
        for (i, score) in scores.enumerated() {
            if score > max {
                max = score
                count = i
            }
        }
        print("max is \(max), count is \(count)")
        
        //check whether there's more than one highest score
        var duplicateItem = [Double]()
        var duplicateItemCount = [Int]()
        for (i, item) in scores.enumerated() {
            if item == max {
                duplicateItem.append(item)
                duplicateItemCount.append(i)
            }
        }
        //return highest-score square
        if duplicateItem.count == 1 {//there's just one max value in array
            print("This return is the square with highest score")
            return count
        }
        print("duplicateItem is \(duplicateItem)")
        
        //return random of those highest-score square's index
        let randomIndex = duplicateItemCount[Int.random(in: 0..<duplicateItemCount.count)]
        
        print("This return is the square with highset score(at:\(randomIndex))\n  , but bcuz there's more than one highest score, it return random of it")
        print(" ")
        return randomIndex
    }
    
    ///- Authors: Idea by Chi
    ///## What he said:
    ///The way to block human is return a board index near by the index of square which human just moved to
    ///
    ///And he said : "The first move is most important, if you take a wrong square in first move, you're over"
    ///
    ///so I decide to record his idea and try to create an AI computer player which is design by Chi
    ///
    ///**_The biggest problem is that how to move as well as he said, return a board index which is near by human just moved to_**
    ///
    ///For example, if human move to square whose `boardIndex` is 0, and AI will return random of 1, 3, 4, because those number is near by the square that human moved to
    func muchSmarterMove(in moves: [Move?]) -> Int {
        //first move(and first move will always human)
        guard moves.compactMap({ $0 }).count == 1 else {
            print(moves.compactMap({ $0 }).count != 1)
            print(moves.compactMap({ $0 }).count)
            return smarterMove(in: moves)
        }
        let movesWithoutNil = moves.compactMap { $0 }
        print(moves.compactMap({ $0 }).count)
        // The logic below is build on there's only one move(and that's definitely human)
//        guard let firstMove = movesWithoutNil.first else { return smarterMove(in: moves) }
        let firstMove = movesWithoutNil[0]
        
        var nearByHumanMoved = [Int]()
        for i in 0..<moves.count {
//            let length = sqrt(Double(firstMove.boardIndex))
            let length = 3.0
            if length == Double(Int(length)) {//length is an interger
                if firstMove.isNearBy(i, length: length) {
                    nearByHumanMoved.append(i)
                }
            }
        }
        print("The square item near by human moved is: \(nearByHumanMoved)")
        let count = nearByHumanMoved.count
        
        return nearByHumanMoved[Int.random(in: 0..<count)]
    }
}

extension Move {
    /// Check the move is near by the input value or not
    /// - Parameters:
    ///   - index: The comporation index of you want to check
    ///   - length: The length of your game status`([Moves?])`
    /// - Returns: return true if it's near by the comporation index and it doesn't out of range of game status array
    func isNearBy<Number: Numeric>(_ index: Int, length: Number) -> Bool {
        guard let lengthOfMoves = length as? Int else { return false }
        let rangeOfIndex = (index - lengthOfMoves - 1)..<(index + lengthOfMoves + 1)
        let movesRange = 0..<9
        
        return rangeOfIndex ~= self.boardIndex && movesRange ~= self.boardIndex && self.boardIndex != index
    }
}

extension Double {
    func rounding(toDecimal decimal: Int) -> Double {
        let numberOfDigist: Double = 10.0 ^ decimal
        return (self * numberOfDigist).rounded(.toNearestOrAwayFromZero)
    }
    
    static func ^(lhs: Double, rhs: Int) -> Double {
        return pow(lhs, Double(rhs))
    }
    
    static func ^=(lhs: inout Double, rhs: Int) {
        lhs = pow(lhs, Double(rhs))
    }
}
