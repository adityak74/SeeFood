import Foundation
import UIKit

protocol MasterModelRecipeDelegate: class {
    func updateData()
    func showData(with text: String)
}

protocol MasterModelWatsonDelegate: class {
    func getFileName() -> URL
}

protocol MasterModelMasterDelegate: class {
    func dismissWatson()
}

class MasterModel {
    
    //MARK:- Vars
    private let session: ApplicationSession
    weak var recipeDelegate: MasterModelRecipeDelegate?
    weak var watsonDelegate: MasterModelWatsonDelegate?
    weak var masterDelegate: MasterModelMasterDelegate?
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
    
    //MARK:- Watson Functions
    func pingWatson(with images: [UIImage]) {
        SwiftSpinner.show("SeeFood is looking through images...")
        
        let numImagesToRecognize = images.count
        var imagesRecognized = 0
        
        var possibleItemsList: [String] = []
        for image in images {
            let compressData = UIImageJPEGRepresentation(image, 0.5) //max value is 1.0 and minimum is 0.0
            let compressedImage = UIImage(data: compressData!)
            if let data = UIImagePNGRepresentation(compressedImage!) {
                let filename = watsonDelegate?.getFileName()
                try? data.write(to: filename!)
                let failure = { (error: Error) in print("🤕\(#function)", error) }
                session.visualRecognition.classify(imageFile: filename!.absoluteURL, failure: failure) { classifiedImages in
                    
                    //MARK:- Examine classes returned from Watson
                    for val in classifiedImages.images[0].classifiers[0].classes {
                        if AppConst.FOOD_LIST.contains(val.classification.lowercased()) && (val.score >= AppConst.VREC_MIN_ACCURACY) {
                            possibleItemsList.append(val.classification.lowercased())
                        }
                    }
                    
                    imagesRecognized += 1
                    if (imagesRecognized == numImagesToRecognize) {
                        SwiftSpinner.hide()
                        DispatchQueue.main.async {
                            self.setIngredients(with: possibleItemsList)
                            self.masterDelegate?.dismissWatson()
                        }
                    }
                }
            }
        }
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
