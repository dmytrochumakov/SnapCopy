//
//  AppView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import CloudKit
import Combine
import Inject
import SimpleToast
import SwiftUI
import TipKit

public struct AppView: View {
    @ObserveInjection private var iO
    @Environment(\.modelContext) private var context
    @State private var showAddItemView: Bool = false
    @State private var showEditItemView: Bool = false
    @State private var showToast: Bool = false
    @State private var selectedEditItem: Item?
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
                    ToolbarItem {
                        HStack(spacing: 0) {
                            Button {
                                showAddItemView = true
                            } label: {
                                Label("Add", systemImage: "plus")
                            }
                            .frame(width: 44, height: 44)
                            .keyboardShortcut(KeyEquivalent("n"), modifiers: .command)
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
        .enableInjection()
    }

    private var listTtemsView: some View {
        ListItemsView(
            onCopy: { item in
                copy(item)
                showToast = true
            },
            onEdit: { item in
                selectedEditItem = item
                showEditItemView = true
            }
        )
    }

    private var pasteButton: some View {
        #if os(iOS)
        return iOSPasteButton
        #elseif os(macOS)
        return macOSPasteButton
        #endif
    }

    private var iOSPasteButton: some View {
        Button("Paste") {
            paste()
        }
        .buttonStyle(AppButtonStyle())
        .padding(16)
        .popoverTip(GoToSettingsTip()) { _ in
            #if os(iOS)
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            #endif
        }
    }

    private var macOSPasteButton: some View {
        Button("Paste") {
            paste()
        }
        .buttonStyle(AppButtonStyle())
        .padding(16)
        .keyboardShortcut(KeyEquivalent("p"), modifiers: .command)
    }

    private func paste() {
        #if os(iOS)
        if let string = UIPasteboard.general.string {
            context.insert(Item(name: string))
        }
        #elseif os(macOS)
        if let string = NSPasteboard.general.string(forType: .string) {
            context.insert(Item(name: string))
        }
        #endif
    }

    func copy(_ item: Item) {
        #if os(iOS)
        UIPasteboard.general.string = item.name
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.name, forType: .string)
        #endif
    }
}

#Preview {
    AppView()
}
