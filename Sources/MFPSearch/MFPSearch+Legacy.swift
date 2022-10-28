//import SwiftUI
//
//extension MFPSearch {
//    var content_legacy: some View {
//        ZStack {
//            navigationView
//                .blur(radius: showingSearchLayer ? 10 : 0)
//            if showingSearchLayer {
//                ZStack {
//                    searchLayer
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    var content_legacy2: some View {
//        if showingSearchActivityIndicator {
//            searchStatus
//        } else {
//            list
//        }
//    }
//    
//    var searchLayer: some View {
//        var keyboardColor: Color {
//            colorScheme == .light ? Color(hex: colorHexKeyboardLight) : Color(hex: colorHexKeyboardDark)
//        }
//
//        var textFieldColor: Color {
//            colorScheme == .light ? Color(hex: colorHexSearchTextFieldLight) : Color(hex: colorHexSearchTextFieldDark)
//        }
//
//        var blurLayer: some View {
//            Color.black.opacity(0.5)
//                .onTapGesture {
//                    resignFocusOfSearchTextField()
//                }
//                .edgesIgnoringSafeArea(.all)
//        }
//        
//        var searchBar: some View {
//            var background: some View {
//                keyboardColor
//                    .frame(height: 65)
//            }
//            
//            var textField: some View {
//                TextField("Search or enter website link", text: $searchViewModel.searchText)
//                    .focused($isFocused)
//                    .font(.system(size: 18))
//                    .keyboardType(.alphabet)
//                    .autocorrectionDisabled()
//                    .onSubmit(searchDidSubmit)
//            }
//            
//            var textFieldBackground: some View {
//                RoundedRectangle(cornerRadius: 15, style: .circular)
//                    .foregroundColor(textFieldColor)
//                    .frame(height: 48)
//            }
//            
//            var searchIcon: some View {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(Color(.secondaryLabel))
//                    .font(.system(size: 18))
//                    .fontWeight(.semibold)
//            }
//            
//            var clearButton: some View {
//                Button {
//                    searchViewModel.searchText = ""
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(Color(.secondaryLabel))
//                }
//                .opacity(searchViewModel.searchText.isEmpty ? 0 : 1)
//            }
//            
//            return ZStack {
//                background
//                ZStack {
//                    textFieldBackground
//                    HStack(spacing: 5) {
//                        searchIcon
//                        textField
//                        Spacer()
//                        clearButton
//                    }
//                    .padding(.horizontal, 12)
//                }
//                .padding(.horizontal, 7)
//            }
//        }
//        
//        return ZStack {
//            Color.clear
//                .contentShape(Rectangle())
//                .background (
//                    .ultraThinMaterial
//                )
//                .onTapGesture {
//                    guard !searchViewModel.results.isEmpty else {
//                        return
//                    }
//                    resignFocusOfSearchTextField()
//                }
//            VStack {
//                HStack {
//                    Button("Cancel") {
//                        tappedCancelOnSearchLayer()
//                    }
//                    .padding()
//                    Spacer()
//                }
//                Spacer()
//            }
//            VStack {
//                Spacer()
//                searchBar
//            }
//        }
//    }
// 
//    var searchStatus: some View {
//        VStack {
//            // Fills the top
//            HStack {
//                Text(searchViewModel.searchText)
//                    .font(.title)
//                    .foregroundColor(.secondary)
//            }
//            .frame(maxHeight: .infinity, alignment: .bottom)
//            
//            // Centered
//            if searchViewModel.loadingFailed {
//                Button {
//                    startSearching()
//                } label: {
//                    Image(systemName: "arrow.clockwise.circle.fill")
//                        .font(.system(size: 60))
//                        .imageScale(.large)
//                }
//            } else if searchViewModel.isLoadingPage {
//                ActivityIndicatorView(isVisible: .constant(true), type: .opacityDots())
//                    .foregroundColor(Color(.tertiaryLabel))
//                    .frame(width: 70, height: 70)
//            }
//            
//            // Fills the bottom
//            HStack {
//                if !searchViewModel.isFirstAttempt {
//                    VStack(spacing: 10) {
//                        if let retryStatusMessage = searchViewModel.errorMessage {
//                            Text(retryStatusMessage)
//                            .foregroundColor(Color(.tertiaryLabel))
//                        }
//                        if let retryCountMessage = searchViewModel.retryMessage {
//                            Text(retryCountMessage)
//                                .foregroundColor(Color(.quaternaryLabel))
//                        }
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(Color(.quaternarySystemFill))
//                    )
//                }
//            }.frame(maxHeight: .infinity, alignment: .top)
//        }
//    }
//    
//    var progressView: some View {
//        ProgressView(value: progressValue, total: 10) {
//            HStack {
//                Spacer()
//                Text("Searching '\(searchViewModel.searchText)'…")
//                    .foregroundColor(.secondary)
//                Spacer()
//            }
//        }
//        .frame(width: 250)
//        .onReceive(timer) { _ in
//            let newValue = progressValue + 0.02
//            guard newValue < 10 else {
//                stopTimer()
//                return
//            }
//            withAnimation {
//                progressValue = newValue
//            }
//        }
//    }
//}
