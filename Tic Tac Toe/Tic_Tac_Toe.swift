//
//  Tic_Tac_Toe.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2023/9/6.
//

import SwiftUI

struct Tic_Tac_Toe: View {
    @StateObject private var viewModel = TicTacToeViewModel()
    
    @Environment(\.colorScheme) private var colorSchreme
    
    private var isLight: Bool {
        colorSchreme == .light
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Menu("", systemImage: "list.bullet") {
                    Button("Play with AI") { viewModel.changeMode(isPlayWithAI: true) }
                    Button("Play with friend") { viewModel.changeMode(isPlayWithAI: false) }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .bold()
                .imageScale(.large)
                .foregroundStyle(.primary)
                
                HStack {
                    ScoreShower(score: viewModel.xScore,
                                isShowIndicator: viewModel.isHumanTurn,
                                backgroundColor: isLight ? .white: .black, 
                                systemImage: "xmark")
                    
                    ScoreShower(score: viewModel.oScore,
                                isShowIndicator: !viewModel.isHumanTurn,
                                backgroundColor: isLight ? .white: .black, 
                                systemImage: "circle")
                }
                .padding()
                
                Button("click") {
                    print(" ")
//                    for i in 0..<9 {
//                        let move = Move(player: .computer, boardIndex: 8)
//                        let isNearByItem = move.isNearBy(i, length: 3)
//                        print("index: \(i), is near by 8: \(isNearByItem)")
//                    }
                    let i = 4
                    let move = Move(player: .computer, boardIndex: 8)
                    let isNearByItem = move.isNearBy(i, length: 3)
                    print("index: \(i), is near by 8: \(isNearByItem)")
                }
                
                LazyVGrid(columns: viewModel.columns, spacing: 8) {
                    ForEach(0..<9) { i in
                        ZStack {
                            TapSquare(color: isLight ? .white: .black, proxy: geometry)
                            
                            if let moves = viewModel.moves[i] {
                                PlayerIndicatorWithAnimation(player: moves.player)
                                    .padding(30)
                            }
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                .disabled(viewModel.isGameDisable)
                .background(.primary.opacity(0.9))
                .padding()
                .transition(.scale)
                
                Button("重新開始遊戲") {
                    viewModel.resetGame()
                }
                .padding(.top)
                .bold()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(item: $viewModel.alertItem, content: {
                Alert(title: $0.title,
                      message: $0.message,
                      dismissButton: .default($0.buttonTitle, action: viewModel.resetGame))
            })
            .animation(.easeInOut(duration: 0.2), value: viewModel.isHumanTurn)
        }
    }
}

struct Tic_Tac_Toe_Previews: PreviewProvider {
    static var previews: some View {
        Tic_Tac_Toe()
    }
}
