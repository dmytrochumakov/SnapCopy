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
        VStack(spacing: 12) {
            TextField("Item content", text: $text)
                .textFieldStyle(AppTextFieldStyle())
            Button("Add") {
                context.insert(Item(name: text))
                dismiss()
            }.buttonStyle(AppButtonStyle())
            Spacer()
        }.padding(16)
            .navigationTitle("Add Item")
    }
}
