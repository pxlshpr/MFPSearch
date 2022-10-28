import SwiftUI
import MFPScraper
import FoodLabel
import PrepDataTypes
import WebKit
import ActivityIndicatorView
import SwiftUISugar

struct MFPFoodView: View {
    
    @EnvironmentObject var searchViewModel: MFPSearch.ViewModel
    @StateObject var mfpFoodViewModel: ViewModel
    @State var showingWebsite: Bool = false
    
    init(result: MFPSearchResultFood, processedFood: MFPProcessedFood? = nil) {
        _mfpFoodViewModel = StateObject(wrappedValue: ViewModel(result: result, processedFood: processedFood))
    }
    
    var body: some View {
        ZStack {
            scrollView
            if !mfpFoodViewModel.isLoadingFoodDetails {
                buttonLayer
                    .transition(.move(edge: .bottom))
            }
        }
        .navigationTitle("Third-Party Food")
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
    
    @ViewBuilder
    var websiteView: some View {
        if let url = mfpFoodViewModel.url {
//            SFSafariViewWrapper(url: url)
//                .edgesIgnoringSafeArea(.all)
            WebView(urlString: url.absoluteString)
        }
    }
    
    var buttonLayer: some View {
        VStack(spacing: 0) {
            Spacer()
            Divider()
            FormPrimaryButton(title: "Prefill this food") {
                if let processedFood = mfpFoodViewModel.processedFood {
                    searchViewModel.selectedFoodHandler(processedFood)
                }
            }
            .padding(.top)
            .background(
                .thinMaterial
            )
        }
    }
    
    var scrollView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    detailSection
                    if mfpFoodViewModel.isLoadingFoodDetails {
                        loadingIndicator
                            .frame(maxHeight: .infinity)
                    } else {
                        foodLabelSection
                        sizesSection
                        linkSection
                        Spacer()
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .safeAreaInset(edge: .bottom) {
                //TODO: Programmatically get this inset (67516AA6)
                Spacer().frame(height: 68)
            }
            .sheet(isPresented: $showingWebsite) {
                websiteView
            }
        }
    }
    
    var detailSection: some View {
        Section {
            VStack(alignment: .center) {
                Text(mfpFoodViewModel.name)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .bold()
//                                .minimumScaleFactor(0.3)
//                                .lineLimit(1)
                if let detailString = mfpFoodViewModel.detailString {
                    Text(detailString)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(.quaternarySystemFill))
            )
            .padding(.top)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    var linkSection: some View {
        if let url = mfpFoodViewModel.url {
            linkButton(for: url)
        }
    }
    
    func linkButton(for url: URL) -> some View {
        NavigationLink {
            WebView(urlString: url.absoluteString)
        } label: {
            HStack {
                HStack {
                    Image(systemName: "link")
                    Text("Website")
                }
                .foregroundColor(.secondary)
                Spacer()
                Text("MyFitnessPal")
                    .foregroundColor(.accentColor)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(Color(.secondarySystemBackground))
            )
            .padding()
            .padding()
        }
    }
    
    @ViewBuilder
    var loadingIndicator: some View {
        VStack {
            Spacer()
            ActivityIndicatorView(isVisible: .constant(true), type: .scalingDots())
                .foregroundColor(Color(.tertiaryLabel))
                .frame(width: 70, height: 70)
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
    
    var sizesSection: some View {
        var header: some View {
            Text("Sizes")
                .font(.title2)
        }
        
        return Group {
            if let sizeViewModels = mfpFoodViewModel.sizeViewModels {
                Section(header: header) {
                    Divider()
                    VStack {
                        ForEach(sizeViewModels, id: \.self) {
                            SizeCell(sizeViewModel: $0)
                                .padding(.vertical, 5)
                            Divider()
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .transition(.opacity)
            }
        }
    }
    
    @ViewBuilder
    var foodLabelSection: some View {
        if mfpFoodViewModel.shouldShowFoodLabel {
            Section {
                mfpFoodViewModel.foodLabel
            }
            .padding()
            .transition(.opacity)
        }
    }
}
