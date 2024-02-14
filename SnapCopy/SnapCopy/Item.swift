//
//  Item.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftData

@Model
final class Item {
    var name: String
    init(name: String) {
        self.name = name
    }
}
