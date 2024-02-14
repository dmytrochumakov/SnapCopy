//
//  GoToSettingsTip.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import TipKit

@available(iOS 17.0, *)
struct GoToSettingsTip: Tip {
    var id: String { Self.titleValue }
    static let titleValue: String = "To avoid annoying meesage about the clipboard access, please go to \nSettings -> SnapCopy -> Allow access to clipboard."
    var title: Text = .init(titleValue)
    var actions: [Action] = [.init {
        Text("Open Settings")
    }]
}
