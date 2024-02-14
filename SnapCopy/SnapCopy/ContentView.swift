//
//  ContentView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import Combine
import SimpleToast
import SwiftUI
import TipKit

final class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var items: [Item] = []
    @Published private(set) var isButtonDisabled = !UIPasteboard.general.hasStrings
    @Published var searchQuery = ""
    @Published var showAddItemView: Bool = false
    @Published var showEditItemView: Bool = false
    @Published var showToast: Bool = false
    var selectedItem: String = ""

    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    func performSearch(query: String) {
        print("Searching for: \(query)")
    }

    func paste() {
        if let string = UIPasteboard.general.string {
            addIfPossible(string)
        }
    }

    func addNewItem(_ newItem: String) {
        addIfPossible(newItem)
    }

    func addIfPossible(_ newItem: String) {
        if !items.contains(where: { $0.name == newItem }) {
            items.append(.init(name: newItem))
        }
    }

    func updatedItem(_ updatedItem: String) {
        if let index = items.firstIndex(where: { $0.name == selectedItem }) {
            items[index] = .init(name: updatedItem)
        }
    }

    func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    func copy(_ item: Item) {
        UIPasteboard.general.string = item.name
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

import SwiftData
@Model
final class Item {
    var name: String
    init(name: String) {
        self.name = name
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query var items: [Item]
    @StateObject private var viewModel = ViewModel()
    private let toastOptions = SimpleToastOptions(
        alignment: .bottom,
        hideAfter: 3
    )
    init() {
        if #available(iOS 17.0, *) {
            #if DEBUG
            try? Tips.resetDatastore()
            #endif
            try? Tips.configure()
        }
    }

    var body: some View {
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
                    EditItenView(text: viewModel.selectedItem, updateTapped: { updatedItem in
                        viewModel.updatedItem(updatedItem)
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
        if #available(iOS 17.0, *) {
            return defaultPasteButton
                .popoverTip(GoToSettingsTip()) { _ in
                    viewModel.goToSettings()
                }
        } else {
            return defaultPasteButton
        }
    }

    private var defaultPasteButton: some View {
        Button("Paste") {
            if let string = UIPasteboard.general.string {
                context.insert(Item(name: string))
            }
        }
        .disabled(viewModel.isButtonDisabled)
    }
}

#Preview {
    ContentView()
}
