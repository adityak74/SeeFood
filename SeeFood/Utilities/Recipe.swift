import Foundation

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let likes: Int
    
    enum CodingKeys : String, CodingKey {
        case id
        case title
        case image
        case imageType
        case usedIngredientCount
        case missedIngredientCount
        case likes
    }
    
    
}

struct RecipeInfo: Codable {
    let instructions: String
    let healthScore: Int
    let readyInMinutes: Int
    
    enum CodingKeys: String, CodingKey {
        case instructions
        case healthScore
        case readyInMinutes
    }
    
}
