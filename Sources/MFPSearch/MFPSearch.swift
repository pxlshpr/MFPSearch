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
    @State var showingSearchActivityIndicator = true

    @State var timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @State var progressValue: Double = 0
    
    public init(didSelectFood: @escaping (MFPProcessedFood) -> ()) {
        let searchViewModel = ViewModel(selectedFoodHandler: didSelectFood)
        _searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    public var body: some View {
        ZStack {
            navigationView
                .blur(radius: showingSearchLayer ? 10 : 0)
            if showingSearchLayer {
                ZStack {
                    searchLayer
                }
            }
        }
        .onAppear {
            focusOnSearchTextField()
        }
        .onDisappear {
            searchViewModel.cancelSearching()
        }
        .interactiveDismissDisabled(shouldDisableInteractiveDismissal)
        .onAppear {
            stopTimer()
        }
        .onChange(of: searchViewModel.results) { newValue in
            guard !newValue.isEmpty else {
                return
            }
            stopTimer()
            Haptics.successFeedback()
            withAnimation {
                progressValue = 10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    self.showingSearchActivityIndicator = false
                }
            }
        }
    }
    
    var shouldDisableInteractiveDismissal: Bool {
        isFocused || !searchViewModel.results.isEmpty
//        !viewModel.results.isEmpty
    }
    
    func focusOnSearchTextField() {
        showingSearchLayer = true
        isFocused = true
    }
    
    func startSearching() {
        withAnimation {
            showingSearchActivityIndicator = true
            searchViewModel.startSearching()
        }
    }
    
    var navigationView: some View {
        var title: String {
            if showingSearchActivityIndicator {
                return "Searching …"
//                return "Search Third-Party Foods"
            } else {
                return "Search Third-Party Foods"
            }
        }
        return NavigationView {
            content
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { navigationTrailingContent }
                .toolbar { navigationLeadingContent }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if showingSearchActivityIndicator {
            searchStatus
        } else {
            list
        }
    }
    
    //MARK: Search
    
    var searchStatus: some View {
        VStack {
            // Fills the top
            HStack {
                Text(searchViewModel.searchText)
                    .font(.title)
                    .foregroundColor(.secondary)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            // Centered
            if searchViewModel.loadingFailed {
                Button {
                    startSearching()
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.system(size: 60))
                        .imageScale(.large)
                }
            } else if searchViewModel.isLoadingPage {
                ActivityIndicatorView(isVisible: .constant(true), type: .scalingDots())
                    .foregroundColor(Color(.tertiaryLabel))
                    .frame(width: 70, height: 70)
            }
            
            // Fills the bottom
            HStack {
                if !searchViewModel.isFirstAttempt {
                    VStack(spacing: 10) {
                        if let retryStatusMessage = searchViewModel.errorMessage {
                            Text(retryStatusMessage)
                            .foregroundColor(Color(.tertiaryLabel))
                        }
                        if let retryCountMessage = searchViewModel.retryMessage {
                            Text(retryCountMessage)
                                .foregroundColor(Color(.quaternaryLabel))
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.quaternarySystemFill))
                    )
                }
            }.frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    var progressView: some View {
        ProgressView(value: progressValue, total: 10) {
            HStack {
                Spacer()
                Text("Searching '\(searchViewModel.searchText)'…")
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .frame(width: 250)
        .onReceive(timer) { _ in
            let newValue = progressValue + 0.02
            guard newValue < 10 else {
                stopTimer()
                return
            }
            withAnimation {
                progressValue = newValue
            }
        }
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }
    
    var navigationLeadingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            if shouldDisableInteractiveDismissal {
                doneButton
            }
        }
    }
    var navigationTrailingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
//            cancelButton
            searchButton
        }
    }
    
    var doneButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
        }
    }
    
    var cancelButton: some View {
        Button {
            searchViewModel.cancelSearching()
        } label: {
            Image(systemName: "xmark.circle.fill")
        }
    }
    
    var searchButton: some View {
        Button {
            withAnimation {
                showingSearchLayer = true
            }
            isFocused = true
        } label: {
            Image(systemName: "magnifyingglass")
        }
    }
    
    func resignFocusOfSearchTextField() {
        withAnimation {
            showingSearchLayer = false
        }
        isFocused = false
    }

    var searchLayer: some View {
        var keyboardColor: Color {
            colorScheme == .light ? Color(hex: colorHexKeyboardLight) : Color(hex: colorHexKeyboardDark)
        }

        var textFieldColor: Color {
            colorScheme == .light ? Color(hex: colorHexSearchTextFieldLight) : Color(hex: colorHexSearchTextFieldDark)
        }

        var blurLayer: some View {
            Color.black.opacity(0.5)
                .onTapGesture {
                    resignFocusOfSearchTextField()
                }
                .edgesIgnoringSafeArea(.all)
        }
        
        var searchBar: some View {
            var background: some View {
                keyboardColor
                    .frame(height: 65)
            }
            
            var textField: some View {
                TextField("Search or enter website link", text: $searchViewModel.searchText)
                    .focused($isFocused)
                    .font(.system(size: 18))
                    .keyboardType(.alphabet)
                    .autocorrectionDisabled()
                    .onSubmit {
                        guard !searchViewModel.searchText.isEmpty else {
                            dismiss()
                            return
                        }
                        resignFocusOfSearchTextField()
                        startSearching()
                    }
            }
            
            var textFieldBackground: some View {
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .foregroundColor(textFieldColor)
                    .frame(height: 48)
            }
            
            var searchIcon: some View {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color(.secondaryLabel))
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
            
            var clearButton: some View {
                Button {
                    searchViewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.secondaryLabel))
                }
                .opacity(searchViewModel.searchText.isEmpty ? 0 : 1)
            }
            
            return ZStack {
                background
                ZStack {
                    textFieldBackground
                    HStack(spacing: 5) {
                        searchIcon
                        textField
                        Spacer()
                        clearButton
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.horizontal, 7)
            }
        }
        
        return ZStack {
            Color.clear
                .contentShape(Rectangle())
                .background (
                    .ultraThinMaterial
                )
                .onTapGesture {
                    guard !searchViewModel.results.isEmpty else {
                        return
                    }
                    resignFocusOfSearchTextField()
                }
            VStack {
                HStack {
                    Button("Cancel") {
                        tappedCancelOnSearchLayer()
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                searchBar
            }
        }
    }
    
    func tappedCancelOnSearchLayer() {
        guard searchViewModel.results.isEmpty else {
            resignFocusOfSearchTextField()
            return
        }
        dismiss()
    }
    
    var list: some View {
        List {
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
            if searchViewModel.isLoadingPage {
                HStack {
                    ActivityIndicatorView(isVisible: .constant(true), type: .opacityDots())
                        .foregroundColor(.secondary)
                        .frame(width: 20, height: 20)
                }
                .frame(maxWidth: .infinity)
            } else {
                Button {
                    searchViewModel.loadNextPage()
                } label: {
                    Text("Load more…")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 10)
                }
            }
        }
    }
}
