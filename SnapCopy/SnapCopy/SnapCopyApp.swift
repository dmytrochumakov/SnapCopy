//
//  SnapCopyApp.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import Packages
import SwiftData
import SwiftUI

@main
struct SnapCopyApp: App {
    var body: some Scene {
        WindowGroup {
            AppView()
                .modelContainer(for: [Item.self])
        }
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Button("Paste") {}
                    .keyboardShortcut(KeyEquivalent("p"), modifiers: .command)
                Button("Add") {}
                    .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
            }
        }
    }
}
