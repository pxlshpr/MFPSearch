import SwiftUI
import MFPScraper
import FoodLabel
import PrepDataTypes

extension MFPFoodView {
    
    class ViewModel: ObservableObject {
        @Published var result: MFPSearchResultFood
        @Published var processedFood: MFPProcessedFood? = nil
        @Published var isLoadingFoodDetails = false
        
        init(result: MFPSearchResultFood, processedFood: MFPProcessedFood? = nil) {
            self.result = result
            self.processedFood = processedFood
            
            if processedFood == nil {

                isLoadingFoodDetails = true
                
                Task(priority: .high) {
                    let food = try await MFPScraper().getFood(for: FoodIdentifier(result.url))
                    await MainActor.run {
                        withAnimation {
                            self.processedFood = food
                            self.isLoadingFoodDetails = false
                        }
                    }
                }
            }
        }
    }
}

extension MFPFoodView.ViewModel {
    
    var servingString: String {
        guard let processedFood else {
            return "1 serving"
        }
        let amountDescription = processedFood.amountDescription.lowercased()
        
        if processedFood.amountUnit == .serving, let servingDescription = processedFood.servingDescription {
            return "\(amountDescription) (\(servingDescription.lowercased()))"
        } else {
            return amountDescription
        }
    }
    
    var name: String {
        result.name
    }
    
    var detail: String {
        result.detail
    }
    
    var brand: String? {
        processedFood?.brand
    }
    
    var sizes: [MFPProcessedFood.Size]? {
        guard let processedFood = processedFood else {
            return nil
        }
        let sizes = processedFood.sizes.filter { !$0.name.isEmpty }
        guard !sizes.isEmpty else {
            return nil
        }
        return sizes
    }
    
    var sizeViewModels: [MFPSizeViewModel]? {
        guard let sizes = sizes else {
            return nil
        }
        return sizes.map { MFPSizeViewModel(size: $0) }
    }
    
    var shouldShowFoodLabel: Bool {
        processedFood != nil
    }
    
    var url: URL? {
        URL(string: "https://myfitnesspal.com\(result.url)")
    }
            
    var firstSize: MFPProcessedFood.Size? {
        sizes?.first
    }
    
    var firstSizeDescription: String? {
        guard let firstSize else {
            return nil
        }
        return "\(firstSize.quantity.cleanAmount) \(firstSize.name)"
    }
    
    var detailString: String? {
        processedFood?.detail ?? processedFood?.brand
    }
    
    var shouldShowDetailString: Bool {
        if let firstSizeDescription,
           firstSizeDescription.lowercased() == detail.lowercased() {
            return false
        } else {
            return true
        }
    }
}
