//
//  UnderWorkAppApp.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/9.
//

import SwiftUI

@main
struct UnderWorkAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
