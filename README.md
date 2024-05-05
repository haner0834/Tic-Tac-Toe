## Tic Tac Toe Game
A tic tac toe game with ai computer player, when the square representing the game state was tapped, the function will be triggered automatically.  
Though there's three functions in [this file](https://github.com/haner0834/Tic-Tac-Toe/blob/main/Tic%20Tac%20Toe/AIPlayer.swift), the illustrate below was all talking about `samrterMove`, the other was not used in this app, and `muchSmarterMove` has't finished.  

## Tic Tac Toe AI

This function returns the AI computer's next move for a tic tac toe game.

### Overview

The function calculates scores for each available square based on certain rules and weights. It then selects the square with the highest score and returns its item count.

### Scoring Rules (First Traversal)

- If the move can lead to a direct win: +4
- If the move can block the human player: +2

### Scoring Rules(Second Traversal)

- If the move can create an opportunity to win: +2
- If the move can block the human player: +1

### Weighting

Each square is assigned a weight:
- Corner square: 0.7
- Middle square: 1.0
- Side square (not a corner): 0.65

The scores are multiplied by their respective weights, and the square with the highest resulting score is chosen.

### Complexity

O(n^2), where n is the length of the array.

### Usage

```swift
// Example usage
let aiPlayer = AIPlayer()
let computerPosition = aiPlayer.smarterMove(in: […])
//or
let computerPosition2 = AIPlayer.main.smarterMove(in: […])
```
