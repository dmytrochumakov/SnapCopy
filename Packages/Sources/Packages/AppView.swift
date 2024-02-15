//
//  AppView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import Combine
import SimpleToast
import SwiftUI
import TipKit

public struct AppView: View {

    @Environment(\.modelContext) private var context
     @State private var showAddItemView: Bool = false
    @State private var showEditItemView: Bool = false
    @State private var showToast: Bool = false

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
                            .navigationDestination(isPresented: $showAddItemView) {
                                AddItemView(addTapped: { newItem in                                    
                                    context.insert(Item(name: newItem))
                                })
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $showEditItemView) {
                    EditItenView(text: "some", updateTapped: { _ in

                    })
                }
            }
        }
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            Label("This is some simple toast message.", systemImage: "exclamationmark.triangle")
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding(.top)
        }
    }

    private var listTtemsView: some View {
        ListItemsView()
    }

    private var pasteButton: some View {
        Button("Paste") {
            if let string = UIPasteboard.general.string {
                context.insert(Item(name: string))
            }
        }
        .popoverTip(GoToSettingsTip()) { _ in
            goToSettings()
        }
    }

    func goToSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    AppView()
}
