//
//  AppView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import SimpleToast
import SwiftUI
import TipKit

public struct AppView: View {
    @Environment(\.modelContext) private var context
    @State private var showAddItemView: Bool = false
    @State private var showEditItemView: Bool = false
    @State private var showToast: Bool = false
    @State private var selectedEditItem: Item?

    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 3
    )

    public init() {
        #if DEBUG
        try? Tips.resetDatastore()
        #endif
        try? Tips.configure()
    }

    public var body: some View {
        ZStack(alignment: .top) {
            NavigationStack {
                VStack(spacing: 0) {
                    pasteButton
                    listTtemsView
                }
                .navigationTitle("SnapCopy")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 0) {
                            Button("Add") {
                                showAddItemView = true
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $showAddItemView) {
                    AddItemView()
                }
                .navigationDestination(isPresented: $showEditItemView) {
                    EditItenView(item: selectedEditItem)
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            Label("Copied", systemImage: "info.circle")
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
        }
    }

    private var listTtemsView: some View {
        ListItemsView(
            onCopy: { item in
                UIPasteboard.general.string = item.name
                showToast = true
            },
            onEdit: { item in
                selectedEditItem = item
                showEditItemView = true
            }
        )
    }

    private var pasteButton: some View {
        Button("Paste") {
            if let string = UIPasteboard.general.string {
                context.insert(Item(name: string))
            }
        }
        .popoverTip(GoToSettingsTip()) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }
}

#Preview {
    AppView()
}
