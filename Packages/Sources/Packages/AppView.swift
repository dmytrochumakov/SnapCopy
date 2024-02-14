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

final class ViewModel: ObservableObject {
    @Published private(set) var isButtonDisabled = !UIPasteboard.general.hasStrings
    @Published var showAddItemView: Bool = false
    @Published var showEditItemView: Bool = false
    @Published var showToast: Bool = false

    func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

public struct AppView: View {
    @Environment(\.modelContext) var context
    @StateObject private var viewModel = ViewModel()
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
                                viewModel.showAddItemView = true
                            }
                            .navigationDestination(isPresented: $viewModel.showAddItemView) {
                                AddItemView(addTapped: { newItem in
                                    // viewModel.addNewItem(newItem)
                                    context.insert(Item(name: newItem))
                                })
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $viewModel.showEditItemView) {
                    EditItenView(text: "some", updateTapped: { _ in

                    })
                }
            }
        }
        .simpleToast(isPresented: $viewModel.showToast, options: toastOptions) {
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
        .disabled(viewModel.isButtonDisabled)
        .popoverTip(GoToSettingsTip()) { _ in
            viewModel.goToSettings()
        }
    }
}

#Preview {
    AppView()
}
