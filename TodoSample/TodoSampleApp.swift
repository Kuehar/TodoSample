//
//  TodoSampleApp.swift
//  TodoSample
//
//  Created by kuehar on 2021/06/08.
//

import SwiftUI

@main
struct TodoSampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
