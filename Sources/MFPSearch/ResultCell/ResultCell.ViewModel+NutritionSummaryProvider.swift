import Foundation
import PrepViews

extension ResultCell.ViewModel: NutritionSummaryProvider {
    var forMeal: Bool {
        false
    }
    
    var isMarkedAsCompleted: Bool {
        false
    }
    
    var showQuantityAsSummaryDetail: Bool {
        false
    }
    
    var energyAmount: Double {
        result.calories
    }
    
    var carbAmount: Double {
        result.carbs
    }
    
    var fatAmount: Double {
        result.fat
    }
    
    var proteinAmount: Double {
        result.protein
    }
}
