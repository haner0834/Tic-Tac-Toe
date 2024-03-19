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
    @State private var isShowLaunchScreen = true
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            ZStack {
                Tic_Tac_Toe()
                if isShowLaunchScreen {
                    LaunchScreen()
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.easeInOut) {
                        isShowLaunchScreen = false
                    }
                }
            }
        }
    }
}
