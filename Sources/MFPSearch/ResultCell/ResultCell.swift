import SwiftUI
import MFPScraper
import ActivityIndicatorView
import PrepViews

struct ResultCell: View {
    @StateObject var viewModel: ViewModel
    
    init(result: MFPSearchResultFood) {
        _viewModel = StateObject(wrappedValue: ViewModel(result: result))
    }

    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    if let detail = viewModel.detailString {
                        Text(detail)
                            .font(.subheadline)
                            .foregroundColor(Color(.secondaryLabel))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            Spacer()
            Text(viewModel.energy)
                .foregroundColor(.secondary)
        }
    }
    
    var content: some View {
        VStack(spacing: 5) {
            title
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    subtitle
//                    details
                }
                Spacer()
                NutritionSummary(dataProvider: viewModel)
            }
        }
    }
    
    var title: some View {
        Text(viewModel.name)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var subtitle: some View {
        if let detailString = viewModel.detailString {
            Text(detailString)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    var details: some View {
        if viewModel.hasProcessedFood {
//            sizesAndNutrients_legacy
            HStack(spacing: 15) {
                sizesButton
                nutrientsButton
            }
        } else {
            ActivityIndicatorView(isVisible: .constant(true), type: .scalingDots())
                .frame(width: 20, height: 20)
                .foregroundColor(Color(.tertiaryLabel))
        }
    }
    
    @ViewBuilder
    var sizesButton: some View {
//        if let sizes = viewModel.sizes {
            Button {
                
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "rectangle.3.group")
                        .imageScale(.small)
                    Text("3")
                        .font(.footnote)
                }
                .foregroundColor(.secondary)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .foregroundColor(Color(.secondarySystemFill))
                )
            }
            .buttonStyle(.borderless)
//        }
    }
    
    @ViewBuilder
    var nutrientsButton: some View {
//        if let nutrients = viewModel.nutrients {
            Button {
                
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "chart.bar.doc.horizontal")
                        .imageScale(.small)
                    Text("7")
                        .font(.footnote)
                }
                .foregroundColor(.secondary)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .foregroundColor(Color(.secondarySystemFill))
                )
            }
            .buttonStyle(.borderless)
//        }
    }
    
    var sizesAndNutrients_legacy: some View {
        @ViewBuilder
        var sizes: some View {
            if let sizesString = viewModel.sizesString {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sizes")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .foregroundColor(Color(.secondarySystemFill))
                        )

                    Text(sizesString)
                        .font(.caption2)
                        .foregroundColor(Color(.tertiaryLabel))
                        .padding(.leading, 4)
                }
            }
        }
        
        
        @ViewBuilder
        var nutrients: some View {
            if let nutrientsString = viewModel.nutrientsString {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Nutrients")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .foregroundColor(Color(.secondarySystemFill))
                        )
                    Text(nutrientsString)
                        .font(.caption2)
                        .foregroundColor(Color(.tertiaryLabel))
                        .padding(.leading, 4)
                }
            }
        }
        
        return VStack(alignment: .leading) {
            sizes
            nutrients
        }
    }

    @ViewBuilder
    var summary: some View {
        if let numberOfSizes = viewModel.numberOfSizes, let numberOfMicros = viewModel.numberOfMicros {
            HStack {
                HStack(spacing: 3) {
                    Text("\(numberOfSizes)")
                        .foregroundColor(.secondary)
                    Text("sizes")
                        .foregroundColor(Color(.tertiaryLabel))
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .foregroundColor(Color(.secondarySystemFill))
                )
                HStack(spacing: 3) {
                    Text("\(numberOfMicros)")
                        .foregroundColor(.secondary)
                    Text("micronutrients")
                        .foregroundColor(Color(.tertiaryLabel))
                }
                .font(.footnote)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .foregroundColor(Color(.secondarySystemFill))
                )
            }
        }
    }
}
