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
    }
}
