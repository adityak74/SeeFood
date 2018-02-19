import Foundation

class MasterModel {
    
    //MARK:- Vars
    private var ingredients: [String] = []
    
    //MARK:- Functions
    func setIngredients(with someIngredients: [String]) {
        if (ingredients.count > 0) {
            self.addIngredient(with: someIngredients)
        } else {
            self.ingredients = someIngredients
        }
    }
    
    func getIngredients() -> [String] {
        return self.ingredients
    }
    
    func clearIngredients() {
        self.ingredients.removeAll()
    }
    
    func addIngredient(with moreIngredients: [String]) {
        for ingredient in moreIngredients {
            self.ingredients.append(ingredient)
        }
    }
}
