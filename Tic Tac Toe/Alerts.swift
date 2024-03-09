//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2023/9/8.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin         = AlertItem(title: Text("u win!"),
                                            message: Text("u beat a super AI"),
                                            buttonTitle: Text("Play again"))
    
    static let computerWin      = AlertItem(title: Text("u lost!"),
                                            message: Text("The super AI beats U :D"),
                                            buttonTitle: Text("Play again"))
    
    static let drawWithComputer = AlertItem(title: Text("Draw"),
                                            message: Text("u have a brain as smart as super AI"),
                                            buttonTitle: Text("Play again"))
    
    static let XWin             = AlertItem(title: Text("X win!"),
                                            message: Text("Part X has smater brain"),
                                            buttonTitle: Text("Play again"))
    
    static let OWin             = AlertItem(title: Text("O win!"),
                                            message: Text("Part O has smater brain"),
                                            buttonTitle: Text("Play again"))
    
    static let drawWithFriend   = AlertItem(title: Text("Draw!"),
                                            message: Text("u guys have same smart brains"),
                                            buttonTitle: Text("Play again"))
}
