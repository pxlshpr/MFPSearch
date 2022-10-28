import SwiftUI
import PrepDataTypes
import FoodLabel
import MFPScraper

extension MFPFoodView.ViewModel {
    
    var foodLabel: FoodLabel {
        FoodLabel(
            energyValue: .constant(energyValue),
            carb: .constant(carbAmount),
            fat: .constant(fatAmount),
            protein: .constant(proteinAmount),
            nutrients: .constant(nutrientsDict),
            amountPerString: .constant(amountPerString),
            showFooterText: false,
            showRDAValues: true
        )
    }
    
    var amountPerString: String {
        guard let processedFood else {
            return "1 serving"
        }
        let amountDescription = processedFood.amountDescription.lowercased()

        if processedFood.amountUnit == .serving, let servingDescription = processedFood.servingDescription {
            if case .size = processedFood.servingUnit {
                return servingDescription.lowercased()
            } else {
                return "\(amountDescription) (\(servingDescription.lowercased()))"
            }
//            let servingUnit = processedFood.servingUnit,
//            servingUnit.isNotSize,
        } else {
            return amountDescription
        }
    }

    var energyValue: FoodLabelValue {
        FoodLabelValue(amount: processedFood?.energy ?? 0, unit: .kcal)
    }

    var carbAmount: Double {
        processedFood?.carbohydrate ?? 0
    }

    var fatAmount: Double {
        processedFood?.fat ?? 0
    }

    var proteinAmount: Double {
        processedFood?.protein ?? 0
    }

    var nutrientsDict: [NutrientType: FoodLabelValue] {
        guard let nutrients = processedFood?.nutrients else {
            return [:]
        }
        return nutrients.reduce(into: [NutrientType: FoodLabelValue]()) {
            $0[$1.type] = $1.foodLabelValue
        }
    }
}

extension  MFPProcessedFood.Nutrient {
    var foodLabelValue: FoodLabelValue {
        FoodLabelValue(amount: amount, unit: unit.foodLabelUnit)
    }
}
