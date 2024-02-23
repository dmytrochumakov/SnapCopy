//
//  ListItemsView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftData
import SwiftUI

struct ListItemsView: View {
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
        #if os(iOS)
        iOSListItemsView(onCopy: onCopy, onEdit: onEdit)
        #elseif os(macOS)
        MacOSListItemsView(onCopy: onCopy, onEdit: onEdit)
        #else
        Text("Unsupported platform")
        #endif
    }
}

struct iOSListItemsView: View {
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
                ListItemsViewCommon.row(for: item, onCopy: onCopy)
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        ListItemsViewCommon.editButton(for: item, onEdit: onEdit)
                            .tint(.blue)
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
}

struct MacOSListItemsView: View {
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
                ListItemsViewCommon.row(for: item, onCopy: onCopy)
                    .contextMenu {
                        ListItemsViewCommon.editButton(for: item, onEdit: onEdit)
                        deleteButton(for: item)
                    }
            }
        }
        .searchable(text: $searchQuery, prompt: "Search Items")
    }

    private func deleteButton(for item: Item) -> some View {
        Button {
            context.delete(item)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}

enum ListItemsViewCommon {
    static func row(for item: Item, onCopy: @escaping (Item) -> Void) -> some View {
        Button(item.name) {
            onCopy(item)
        }
        .font(.system(size: 20, weight: .regular))
        .foregroundColor(.primary)
    }

    static func editButton(for item: Item, onEdit: @escaping (Item) -> Void) -> some View {
        Button {
            onEdit(item)
        } label: {
            Label("Edit", systemImage: "square.and.pencil")
        }
    }
}
