import UIKit

protocol RecipeViewControllerDelegate: class {
    func clearAll()
    func addIngredients()
    func setCurrentRecipes()
    func getCurrentRecipes() -> [Recipe]
    func getSelectedRecipeInstructions(from index: Int)
}

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Vars
    var selectedRecipeInstructions: String?
    var delegate: RecipeViewControllerDelegate?
    
    //MARK:- Outlets
    @IBOutlet weak var recipeTableView: UITableView!
    
    //MARK:- Primary View Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipeTableView.delegate = self
        self.recipeTableView.dataSource = self
        self.delegate?.setCurrentRecipes()
    }
    
    //MARK:- Functions
    func reloadData() {
        self.recipeTableView.reloadData()
    }
    
    //MARK:- Actions
    @IBAction func clearButtonTapped(_ sender: Any) {
        delegate?.clearAll()
    }
    
    @IBAction func addIngredientButtonTapped(_ sender: Any) {
        delegate?.addIngredients()
    }
    
    //MARK:- Segues
    func signalPrepare(with text: String) {
        self.selectedRecipeInstructions = text
        self.performSegue(withIdentifier: "recipeInfoSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeInfoSegue" {
            if let indexPath = recipeTableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! RecipeInfoViewController
                detailVC.title = (delegate?.getCurrentRecipes())![indexPath.row].title
                detailVC.instructionsText = selectedRecipeInstructions
            }
        }
    }
    
    //MARK:- UITableviewDelegate Functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getSelectedRecipeInstructions(from: indexPath.row)
    }
    
    //MARK:- UITableViewDataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (delegate?.getCurrentRecipes().count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = (delegate?.getCurrentRecipes())![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeTableViewCell!
        cell?.recipeNameLabel.text = recipe.title
        cell?.recipeImageView.downloadedFrom(link: recipe.image)
        return cell!
    }
}

//MARK:- Delegates
extension RecipeViewController: MasterModelRecipeDelegate {

    func updateData() {
        reloadData()
    }
    
    func showData(with text: String) {
        signalPrepare(with: text)
    }
}
