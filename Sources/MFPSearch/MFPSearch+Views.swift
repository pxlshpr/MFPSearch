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
}
