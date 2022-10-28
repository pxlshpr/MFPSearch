import SwiftUI
import ActivityIndicatorView
import SwiftHaptics
import MFPScraper
import SwiftUISugar

public struct MFPSearch: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject var searchViewModel: ViewModel
    
    @FocusState var isFocused: Bool
    @State var showingSearchLayer: Bool = false
    @State var showingSearchActivityIndicator = false

    @State var timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @State var progressValue: Double = 0
    
    public init(didSelectFood: @escaping (MFPProcessedFood) -> ()) {
        let searchViewModel = ViewModel(selectedFoodHandler: didSelectFood)
        _searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    public var body: some View {
        content
        .onAppear(perform: appeared)
        .onDisappear(perform: disappeared)
        .interactiveDismissDisabled(shouldDisableInteractiveDismissal)
        .onChange(of: searchViewModel.results, perform: handleResultsChange)
    }
    
    var content: some View {
        navigationView
    }
    
    var navigationView: some View {
        NavigationView {
            Group {
                SearchableView(
                    searchText: $searchViewModel.searchText,
                    prompt: "Search or enter website link",
                    didSubmit: searchDidSubmit
                ) {
                    list
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { navigationTrailingContent }
            .toolbar { navigationLeadingContent }
        }
    }
    
    var list: some View {
        List {
            results
            bottomCell
        }
    }
    
    var results: some View {
        ForEach(searchViewModel.results, id: \.self) { result in
            NavigationLink {
                MFPFoodView(result: result, processedFood: searchViewModel.food(for: result))
                    .environmentObject(searchViewModel)
            } label: {
                ResultCell(result: result)
                    .onAppear {
                        searchViewModel.loadMoreContentIfNeeded(currentResult: result)
                    }
                    .contentShape(Rectangle())
            }
        }
    }
    
    @ViewBuilder
    var bottomCell: some View {
        if searchViewModel.isLoadingPage {
            activityCell
        } else if searchViewModel.isFirstAttempt {
            emptyCell
        } else {
            loadMoreCell
        }
    }
    
    var emptyCell: some View {
        Group {
            Section {
                Text("""
Search over 11 million foods in the [MyFitnessPal](https://www.myfitnesspal.com) database.
""")
                .foregroundColor(.secondary)
                .listRowSeparator(.hidden)
                Text("""
As we rely on their servers for this information, its accuracy and the speed at which it is retrieved cannot be guaranteed. The availability of this feature might also be intermittently unavilabile.
""")
                .foregroundColor(Color(.tertiaryLabel))
                .listRowSeparator(.hidden)
            }
//            Section {
//                Text("""
//As we rely on their servers for this information—its accuracy and the speed at which it is retrieved cannot be guaranteed. The availability of this feature might also be intermittently unavilabile.
//""")
//                .foregroundColor(.secondary)
//            }
            Section("Disclaimer") {
                Text("""
We are in no way affiliated with MyFitnessPal, and do not claim ownership over any of the data they provide.
""")
                .italic()
                .foregroundColor(.secondary)
            }
        }
    }
    
    var activityCell: some View {
        HStack {
            ActivityIndicatorView(isVisible: .constant(true), type: .opacityDots())
                .foregroundColor(.secondary)
                .frame(width: 30, height: 30)
        }
        .frame(maxWidth: .infinity)
    }
    
    var loadMoreCell: some View {
        Button {
            searchViewModel.loadNextPage()
        } label: {
            Text("Load more…")
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 10)
        }
    }
}
