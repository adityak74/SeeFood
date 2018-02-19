import UIKit

class RecipeInfoViewController: UIViewController {
    
    //MARK:- Vars
    let rapidService = RapidService()
    var selectedRecipe: Recipe!
    
    //MARK:- Outlets
    @IBOutlet weak var recipeTitle: UINavigationItem!
    @IBOutlet weak var recipeInstructions: UITextView!
    
    //MARK:- ViewController Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Fetching recipe : " + selectedRecipe.title)
        print(selectedRecipe.id)
        self.title = selectedRecipe.title
        rapidService.getRecipeInfo(from: selectedRecipe) { (recipeInfo) in
            
            DispatchQueue.main.async {
                self.recipeInstructions.text = recipeInfo!.instructions
                SwiftSpinner.hide()
            }
        }
    }
}
