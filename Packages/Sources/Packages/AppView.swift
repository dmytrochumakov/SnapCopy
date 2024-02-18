//
//  AppView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import CloudKit
import Combine
import SimpleToast
import SwiftUI
import TipKit

public struct AppView: View {
    @Environment(\.modelContext) private var context
    @State private var showAddItemView: Bool = false
    @State private var showEditItemView: Bool = false
    @State private var showToast: Bool = false
    @State private var selectedEditItem: Item?
    @State private var pasteButtonDisabled: Bool = UIPasteboard.general.string == nil
    @State private var cancellables = Set<AnyCancellable>()

    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 3
    )

    public init() {
        #if DEBUG
        try? Tips.resetDatastore()
        #endif
        try? Tips.configure()
        subscribeToPasteboard()
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
                            Button {
                                showAddItemView = true
                            } label: {
                                Label("Add", systemImage: "plus")
                            }
                            .frame(width: 44, height: 44)
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
        .disabled(pasteButtonDisabled)
        .buttonStyle(AppButtonStyle())
        .padding(16)
        .popoverTip(GoToSettingsTip()) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
    }

    private func subscribeToPasteboard() {
        NotificationCenter
            .default
            .publisher(for: UIPasteboard.changedNotification)
            .sink { _ in
                pasteButtonDisabled = UIPasteboard.general.string == nil
            }
            .store(in: &cancellables)
    }
}

#Preview {
    AppView()
}
