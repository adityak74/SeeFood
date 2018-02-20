import Foundation

protocol MasterModelDelegate: class {
    func updateData()
    func showData(with text: String)
}

class MasterModel {
    
    //MARK:- Vars
    private let session: ApplicationSession
    weak var recipeDelegate: MasterModelDelegate?
    private var ingredients: [String]
    private var recipes: [Recipe]
    
    //MARK:- Init
    init() {
        self.session = ApplicationSession()
        self.ingredients = []
        self.recipes = []
    }
    
    /*
     init(session: ApplicationSession) {
        self.session = session
     }
    */
    
    //MARK:- Clear Ingredients and Recipes
    func clearAll() {
        self.ingredients.removeAll()
        self.recipes.removeAll()
    }
    
    //MARK:- Ingredients Functions
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
    
    func addIngredient(with moreIngredients: [String]) {
        for ingredient in moreIngredients {
            self.ingredients.append(ingredient)
        }
    }
    
    //MARK:- Recipes Functions
    func setRecipes() {
        self.session.rapidService.getRecipes(from: ingredients) { (resultRecipies) in
            self.recipes = resultRecipies!
            DispatchQueue.main.async {
                self.recipeDelegate?.updateData()
            }
        }
    }
    
    func getRecipes() -> [Recipe] {
        return self.recipes
    }
    
    func getRecipeInstructions(from index: Int) {
        SwiftSpinner.show("Fetching recipe: " + recipes[index].title)
        session.rapidService.getRecipeInfo(from: recipes[index]) { (recipeInfo) in
            DispatchQueue.main.async {
                SwiftSpinner.hide()
                self.recipeDelegate?.showData(with: (recipeInfo?.instructions)!)
            }
        }
    }
}
