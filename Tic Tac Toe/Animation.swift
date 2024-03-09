//
//  Animation.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2024/3/3.
//

import Foundation
import SwiftUI

struct CustomTransition: ViewModifier {
    let width: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width)
    }
}

extension AnyTransition {
    static func width(max maxWidth: CGFloat = .infinity) -> AnyTransition {
        AnyTransition.modifier(
            active: CustomTransition(width: 0),
            identity: CustomTransition(width: maxWidth)
        )
    }
    
    static var width: AnyTransition {
        AnyTransition.modifier(
            active: CustomTransition(width: 0),
            identity: CustomTransition(width: 130)
        )
    }
}

