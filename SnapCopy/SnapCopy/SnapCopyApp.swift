//
//  SnapCopyApp.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import SwiftUI
import SwiftData

@main
struct SnapCopyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .modelContainer(for: [Item.self], inMemory: true)
        }
    }
}
