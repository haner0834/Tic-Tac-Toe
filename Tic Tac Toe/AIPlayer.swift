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
    ///## These are pattern of first traversing input:
    ///  If AI can win deractly in this square, return the square.
    ///
    ///  If AI can't win, block human.
    ///
    ///  If AI can't block human, take the middle square
    ///
    ///
    /// At the same time(loop), the function will scoring each square
    ///
    /// After running these, find the highest score and return it
    ///
    /// If there's more than one highest score(same high score), return random of it
    ///
    /// - Complexity: O(n^2 + 3n), when n is length of array
    func smarterMove(in moves: [Move?]) -> Int {
        let checker = MoveChecker()
        var scores = Array(repeating: 0, count: moves.count)
        
        for i in 0..<moves.count {
            let isSquareOccupied = checker.isSquareOccupied(in: moves, forIndex: i)
            if !isSquareOccupied {
                //we expect AI move to this square
                var expectMove = moves
                
                //if AI can win deractly, return this square
                expectMove[i] = Move(player: .computer, boardIndex: i)
                if checker.checkWin(in: expectMove, for: .computer) {
                    print("AI can win, so select this square")
                    return i
                }
                
                //if AI can block, return this square
                expectMove[i] = Move(player: .human, boardIndex: i)
                if checker.checkWin(in: expectMove, for: .human) {
                    print("Human can win, so select this square")
                    return i
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
                            let winTimesInSameMove = checker.checkWinTimesInSameMove(in: expect, for: .computer)
                            scores[i] += 2 * winTimesInSameMove
                            print("this move will create an opportunity of computer, so score +\(scores[i])(in\(i), \(j))")
                        }
                        
                        //check human can win in this move
                        expect[i] = Move(player: .human, boardIndex: i)
                        expect[j] = Move(player: .human, boardIndex: j)
                        if checker.checkWin(in: expect, for: .human) {
                            let winTimesInSameMove = checker.checkWinTimesInSameMove(in: expect, for: .human)
                            scores[i] += 1 * winTimesInSameMove
                            print("this move probably block human, so score +\(scores[i])(in\(i), \(j))")
                        }
                    }
                }
            }
        }
        //if the middle square hasn't be occupied, return it
        print("scores : \(scores)")
        if !checker.isSquareOccupied(in: moves, forIndex: 4) {
            print("bcuz middle square aren't occupied")
            return 4
        }
        
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
        var duplicateItem = [Int]()
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
}

