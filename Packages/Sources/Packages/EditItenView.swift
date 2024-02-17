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
        VStack(spacing: 12) {
            TextField("Item content", text: $text)
                .textFieldStyle(AppTextFieldStyle())
            Button("Update") {
                if let item {
                    item.name = text
                }
                dismiss()
            }.buttonStyle(AppButtonStyle())
            Spacer()
        }.padding(16)
            .navigationTitle("Edit Item")
    }
}
