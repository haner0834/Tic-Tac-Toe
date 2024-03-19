//
//  LaunchScreen.swift
//  TicTacToe
//
//  Created by Andy Lin on 2024/3/17.
//

import SwiftUI

struct LaunchScreen: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @State private var isShowSquare: [Bool] = [false, false, false]
    
    var body: some View {
        VStack {
            ZStack {
                Color(red: 0.078, green: 0.078, blue: 0.078)
                
                VStack {
                    Rectangle()
                        .frame(width: 200, height: 5)
                    
                    Color.clear.frame(height: 50)
                    
                    Rectangle()
                        .frame(width: 200, height: 5)
                }
                .foregroundStyle(.white)
                .offset(x: -6)
                .frame(width: 355, height: 355)
                
                HStack {
                    Rectangle()
                        .frame(width: 5, height: 190)
                    
                    Color.clear.frame(width: 61)
                    
                    Rectangle()
                        .frame(width: 5, height: 190)
                }
                .foregroundStyle(.white)
                .offset(x: -3)
                
                if isShowSquare[0] {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                        .frame(width: 45, height: 45)
                        .offset(x: -3, y: -71)
                }
                
                if isShowSquare[2] {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(red: 0.997, green: 0.947, blue: 0.697))
                        .frame(width: 45, height: 45)
                        .offset(x: -4, y: 71)
                }
                
                if isShowSquare[1] {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                        .frame(width: 45, height: 45)
                        .offset(x: -83, y: 71)
                }
            }
            .frame(width: 355, height: 355)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.078, green: 0.078, blue: 0.078))
        .onAppear {
            let delayTimes = [0.2, 0.7, 1.6]
            for i in 0..<3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayTimes[i]) {
                    print("hello")
                    withAnimation(.easeInOut) {
                        isShowSquare[i].toggle()
                    }
                }
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
