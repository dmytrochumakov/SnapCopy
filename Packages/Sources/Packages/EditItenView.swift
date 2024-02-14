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
    private let updateTapped: (String) -> Void
    init(text: String, updateTapped: @escaping (String) -> Void) {
        _text = State(initialValue: text)
        self.updateTapped = updateTapped
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Item content", text: $text)
            Button("Update") {
                updateTapped(text)
                dismiss()
            }
            Spacer()
        }
    }
}
