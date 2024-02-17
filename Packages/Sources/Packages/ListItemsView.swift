//
//  ListItemsView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftData
import SwiftUI

struct ListItemsView: View {
    @Environment(\.modelContext) private var context
    @Query private var items: [Item]
    @State private var searchQuery = ""

    private var filteredItems: [Item] {
        if searchQuery.isEmpty {
            return items
        }
        return items.filter { $0.name.contains(searchQuery) }
    }

    private let onCopy: (Item) -> Void
    private let onEdit: (Item) -> Void

    init(
        onCopy: @escaping (Item) -> Void,
        onEdit: @escaping (Item) -> Void
    ) {
        self.onCopy = onCopy
        self.onEdit = onEdit
    }

    var body: some View {
        List {
            ForEach(filteredItems) { item in
                row(for: item)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let item = items[index]
                    context.delete(item)
                }
            }
        }
        .searchable(text: $searchQuery, prompt: "Search Items")
    }

    func row(for item: Item) -> some View {
        Button {
            onCopy(item)
        } label: {
            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(.primary)
        }
        .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in
            onEdit(item)
        })
    }
}
