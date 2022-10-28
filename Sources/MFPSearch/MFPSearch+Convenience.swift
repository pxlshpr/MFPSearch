import Foundation

extension MFPSearch {
    
    var shouldDisableInteractiveDismissal: Bool {
        isFocused || !searchViewModel.results.isEmpty
    }

    var title: String {
        if showingSearchActivityIndicator {
            return "Searching …"
//                return "Search Third-Party Foods"
        } else {
            return "Search MyFitnessPal"
        }
    }

}
