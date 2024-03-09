//
//  TicTacToeView.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2024/3/3.
//

import Foundation
import SwiftUI

struct Title: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Text("Tic Tac Toe")
            .padding(.trailing, proxy.size.width * 0.6)
            .padding(.top)
            .font(.title.bold())
    }
}

struct ReStartButton: View {
    var color: Color
    var action: () -> Void
    
    init(color: Color, perform action: @escaping () -> Void) {
        self.color = color
        self.action = action
    }
    
    var body: some View {
        HStack {
            Image(systemName: "repeat")
            
            Text("重置")
        }
        .foregroundColor(color)
        .font(.title2.bold())
        .padding()
        .background(.blue).opacity(0.8)
        .cornerRadius(30)
        .onTapGesture(perform: action)
    }
}

struct ModePicker: View {
    @StateObject private var viewModel = TicTacToeViewModel()
    @Binding var selection: Bool
    
    var body: some View {
        HStack {
            Text("模式")
                .font(.title3.bold())
                .padding(.trailing)
            Picker("", selection: $selection) {
                Text("AI")
                    .tag(true)
                
                Text("對戰")
                    .tag(false)
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }
}

struct TapSquare: View {
    var color: Color
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .frame(width: proxy.size.width / 3 - 15,
                   height: proxy.size.width / 3 - 15)
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .bold()
    }
}

struct ScoreDisplay: View {
    var score: String
    var systemImageName: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImageName)
            Text(score)
                .frame(maxWidth: .infinity)
        }
        .padding(7)
        .background(Rectangle()
            .foregroundColor(Color(red: 0.198, green: 0.584, blue: 0.999))
            .opacity(0.4)
            .cornerRadius(15)
        )
    }
}

struct ScoreShower: View {
    let score: Int
    let isShowIndicator: Bool
    let backgroundColor: Color
    let systemImage: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: systemImage)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(score == 0 ? "-": "\(score)")
                    .padding(.trailing, 5)
            }
            .fontWeight(.bold)
            .padding(.horizontal, 5)
            .padding(7)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .padding(.bottom, 4)
        }
        .background {
            if isShowIndicator {
                Color.blue.opacity(0.8)
                    .transition(.scale.animation(.easeInOut.delay(0.1)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
        }
    }
}

struct PlayerIndicatorWithAnimation: View {
    var player: Player
    
    var body: some View {
        switch player {
        //cirlce
        case .computer:
            CircleIndicator()
                .foregroundStyle(Color("CircleYellow"))
        //x
        case .human:
            XmarkIndicator()
                .foregroundStyle(.primary)
        }
    }
}

struct CircleIndicator: View {
    @State private var circleEnd: CGFloat = 0
    var body: some View {
        Circle()
            .trim(from: 0, to: circleEnd)
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .onAppear {
                withAnimation {
                    circleEnd = 1
                }
            }
    }
}

struct XmarkIndicator: View {
    let maxWidth: CGFloat = 30
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .rotationEffect(Angle(degrees: 45))
                .frame(height: 6)
                .transition(.width.animation(.easeInOut(duration: 0.2).delay(0.1)))
            RoundedRectangle(cornerRadius: 10)
                .rotationEffect(Angle(degrees: -45))
                .frame(height: 6)
                .transition(.width.animation(.easeInOut(duration: 0.2).delay(0.1)))
        }
        .transition(.width.animation(.easeInOut(duration: 0.2).delay(0.1)))
    }
}

#Preview(body: {
    Color.blue
})
