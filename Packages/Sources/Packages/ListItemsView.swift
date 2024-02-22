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
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        editButton(for: item)
                            .tint(.blue)
                    }
                    .contextMenu {
                        editButton(for: item)
                        deleteButton(for: item)
                    }
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

    private func row(for item: Item) -> some View {
        Button(item.name) {
            onCopy(item)
        }
        .font(.system(size: 20, weight: .regular))
        .foregroundColor(.primary)
    }

    private func editButton(for item: Item) -> some View {
        Button {
            onEdit(item)
        } label: {
            Label("Edit", systemImage: "square.and.pencil")
        }
    }

    private func deleteButton(for item: Item) -> some View {
        Button {
            context.delete(item)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}
