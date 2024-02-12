//
//  ContentView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import Combine
import SwiftUI
import TipKit

final class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var items: [Item] = []
    @Published private(set) var isButtonDisabled = !UIPasteboard.general.hasStrings
    @Published var searchQuery = ""
    @Published var showAddItemView: Bool = false

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

    func addIfPossible(_ newItem: String)  {
if !items.contains(where: { $0.name == newItem }) {
                items.append(.init(name: newItem))
            }
    }

    func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

struct Item: Identifiable, Hashable {
    var id: String { name }
    let name: String
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    init() {
        if #available(iOS 17.0, *) {
            #if DEBUG
            try? Tips.resetDatastore()
            #endif
            try? Tips.configure()
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                pasteButton
                listTtemsView
                NavigationLink(
                    destination: AddItemView(addTapped: { newItem in 
                        viewModel.addNewItem(newItem)
                    }), 
                    isActive: $viewModel.showAddItemView
                    ) { EmptyView() }
            }
            .navigationTitle("SnapCopy")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 0) {
                        Button("Add") {
                            viewModel.showAddItemView = true
                        }
                    }
                }
            }
        }
    }

    private var listTtemsView: some View {
        List(viewModel.items) { item in
            TextField("Item", text: .constant(item.name))
        }
        .searchable(text: $viewModel.searchQuery, prompt: "Search Items")
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
            viewModel.paste()
        }
        .disabled(viewModel.isButtonDisabled)
    }
}

#Preview {
    ContentView()
}

@available(iOS 17.0, *)
struct GoToSettingsTip: Tip {
    var id: String { Self.titleValue }
    static let titleValue: String = "To avoid annoying meesage about the clipboard access, please go to \nSettings -> SnapCopy -> Allow access to clipboard."
    var title: Text = .init(titleValue)
    var actions: [Action] = [.init {
        Text("Open Settings")
    }]
}

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss

    @State private var text: String = ""
    private let addTapped: (String) -> Void
    init(addTapped: @escaping (String) -> Void) {
        self.addTapped = addTapped
    }

    var body: some View {
        VStack(spacing: 0) {
            TextField("Item content", text: $text)
            Button("Add") {
                addTapped(text)
                dismiss()
            }
            Spacer()
        }
    }
}
