//
//  AddItemView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftUI

public struct AddItemView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var text: String = ""

    public var body: some View {
        VStack(spacing: 0) {
            TextField("Item content", text: $text)
            Button("Add") {
                context.insert(Item(name: text))
                dismiss()
            }
            Spacer()
        }
        .navigationTitle("Add Item")
    }
}
