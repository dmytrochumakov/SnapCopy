//
//  ListItemsView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 14.02.2024.
//

import SwiftData
import SwiftUI

struct ListItemsView: View {
    @Environment(\.modelContext) var context
    @Query private var items: [Item]
    @State private var searchQuery = ""
    var body: some View {
        List {
            ForEach(items) { item in
                Text(item.name)
                    .onTapGesture {
                        // copy
                    }
                    .onLongPressGesture {
                        // edit
                    }
            }
            .onDelete { _ in
            }
        }
        .searchable(text: $searchQuery, prompt: "Search Items")
    }
}
