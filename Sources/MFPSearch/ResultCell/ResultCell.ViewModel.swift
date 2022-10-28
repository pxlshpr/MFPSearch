import SwiftUI
import MFPScraper

extension ResultCell {
    
    class ViewModel: ObservableObject {
        
        @Published var result: MFPSearchResultFood
        @Published var processedFood: MFPProcessedFood? = nil
        
        init(result: MFPSearchResultFood) {
            self.result = result
        }
    }
}

extension ResultCell.ViewModel {
    var name: String {
        result.name
    }
    
    var energy: String {
        "\(result.calories.cleanAmount) kcal"
    }
    
    var numberOfSizes: Int? {
        processedFood?.sizes.count
    }
    
    var numberOfMicros: Int? {
        processedFood?.nutrients.count
    }
    
    var sizes: [MFPProcessedFood.Size]? {
        processedFood?.sizes
    }
    
    var nutrients: [MFPProcessedFood.Nutrient]? {
        processedFood?.nutrients
    }
    
    var sizesString: String? {
        guard let sizes = processedFood?.sizes, !sizes.isEmpty else {
            return nil
        }
        let string = sizes.map { $0.name }.joined(separator: ", ")
        return string.isEmpty ? nil : string
    }
    
    var nutrientsString: String? {
        guard let nutrients = processedFood?.nutrients, !nutrients.isEmpty else {
            return nil
        }
        let string = nutrients.map { $0.type.description.lowercased() }.joined(separator: ", ")
        return string.isEmpty ? nil : string
    }
    
    var detailString: String? {
        if let brand = processedFood?.brand {
            if let detail = processedFood?.detail {
                return "\(brand) • \(detail)"
            } else {
                return brand
            }
        } else if let detail = processedFood?.detail {
            return detail
        } else if !result.detail.isEmpty {
            return result.detail
        }
        return nil
    }
    
    var hasProcessedFood: Bool {
        processedFood != nil
    }
}
