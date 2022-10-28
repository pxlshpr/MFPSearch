import SwiftUI
import SwiftHaptics
import MFPScraper

extension MFPSearch {

    func searchDidSubmit() {
        guard !searchViewModel.searchText.isEmpty else {
            dismiss()
            return
        }
        resignFocusOfSearchTextField()
        startSearching()
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
    
    func handleResultsChange(results: [MFPSearchResultFood]) {
        guard !results.isEmpty else {
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
    
    func resignFocusOfSearchTextField() {
        withAnimation {
            showingSearchLayer = false
        }
        isFocused = false
    }

    func tappedCancelOnSearchLayer() {
        guard searchViewModel.results.isEmpty else {
            resignFocusOfSearchTextField()
            return
        }
        dismiss()
    }
    
    func appeared() {
        focusOnSearchTextField()
        stopTimer()
    }
    
    func disappeared() {
        searchViewModel.cancelSearching()
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    }
}
