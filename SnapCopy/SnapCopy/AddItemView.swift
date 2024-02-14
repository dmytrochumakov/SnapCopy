//
//  AddItemView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss

    @State private var text: String = ""
    private let addTapped: (String) -> Void
    init(addTapped: @escaping (String) -> Void) {
        self.addTapped = addTapped
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Item content", text: $text)
            Button("Add") {
                addTapped(text)
                dismiss()
            }
            Spacer()
        }
    }
}
