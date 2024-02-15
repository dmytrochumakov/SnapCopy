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

    init(item: Item?) {
        _text = State(initialValue: item?.name ?? "")
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Item content", text: $text)
            Button("Update") {                             
                dismiss()
            }
            Spacer()
        }
        .navigationTitle("Edit Item")
    }
}
