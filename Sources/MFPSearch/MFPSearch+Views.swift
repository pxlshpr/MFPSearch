import SwiftUI
import ActivityIndicatorView
import SwiftUISugar

extension MFPSearch {
    
    var navigationLeadingContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarLeading) {
            if shouldDisableInteractiveDismissal {
                doneButton
            }
        }
    }
    
    var doneButton: some View {
        Button {
            searchViewModel.cancelSearching()
            dismiss()
        } label: {
            closeButtonLabel
        }
    }    
}
