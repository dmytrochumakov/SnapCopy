//
//  EditItenView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftUI

struct EditItenView: View {
    @Environment(\.dismiss) var dismiss
    @State private var text: String
    private var item: Item?
    init(item: Item?) {
        self.item = item
        _text = State(initialValue: item?.name ?? "")
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Item content", text: $text)
            Button("Update") {
                if let item {
                    item.name = text
                }
                dismiss()
            }
            Spacer()
        }
        .navigationTitle("Edit Item")
    }
}
