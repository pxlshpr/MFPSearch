import SwiftUI
import ActivityIndicatorView

extension MFPSearch {
    
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
}
