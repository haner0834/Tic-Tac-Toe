//
//  Tic_Tac_ToeApp.swift
//  Tic Tac Toe
//
//  Created by Andy Lin on 2023/9/6.
//

import SwiftUI

@main
struct Tic_Tac_ToeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            Tic_Tac_Toe()
        }
    }
}
