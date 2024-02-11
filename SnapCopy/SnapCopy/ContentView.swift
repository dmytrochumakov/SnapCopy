//
//  ContentView.swift
//  SnapCopy
//
//  Created by Dmytro Chumakov on 10.02.2024.
//

import SwiftUI
import TipKit
import Combine

final class ViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var items: [Item] = []
    @Published private(set) var isButtonDisabled = !UIPasteboard.general.hasStrings
    @Published var searchQuery = ""

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
            if !items.contains(where: { $0.name == string }) {
                items.append(.init(name: string))
            }
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
                List(viewModel.items) {  item in
                    TextField("Item", text: .constant(item.name))
                }
                .navigationTitle("SnapCopy")
                    .searchable(text: $viewModel.searchQuery, prompt: "Search Items")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            HStack(spacing: 0) {
                                Button("Add") {

                                }
                            }
                        }
                    }
            }
        }

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
    var title: Text = Text(titleValue)
    var actions: [Action] = [.init({
        Text("Open Settings")
    })]
}
