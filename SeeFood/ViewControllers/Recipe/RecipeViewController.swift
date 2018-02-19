import UIKit

protocol RecipeViewControllerDelegate: class {
    func clearIngredients()
    func addIngredients()
}

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Outlets
    @IBOutlet weak var recipeTableView: UITableView!
    
    //MARK:- Vars
    var ingredients: [String]?
    private var recipies: [Recipe] = []
    let rapidService = RapidService()
    var delegate: RecipeViewControllerDelegate?
    
    //MARK:- Primary View Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        print("\(#function):Got ingredients:\(String(describing: ingredients))")
        
        rapidService.getRecipes(from: ingredients!) { (resultRecipies) in
            self.recipies = resultRecipies!
            DispatchQueue.main.async {
                print("Got Recipies : ", self.recipies.count)
                self.recipeTableView.reloadData()
            }
        }
        
    }
    
    //MARK:- Actions
    @IBAction func clearButtonTapped(_ sender: Any) {
        delegate?.clearIngredients()
    }
    
    @IBAction func addIngredientButtonTapped(_ sender: Any) {
        delegate?.addIngredients()
    }
    
    //MARK:- Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeInfoSegue" {
            if let indexPath = recipeTableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let detailVC = segue.destination as! RecipeInfoViewController
                detailVC.selectedRecipe = self.recipies[selectedRow]
            }
        }
    }
    
    //MARK:- UITableviewDelegate Functions
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "recipeInfoSegue", sender: self)
    }
    
    //MARK:- UITableViewDataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(#function)",self.recipies.count)
        return self.recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cur recipe : ", indexPath.row)
        let recipe = self.recipies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeTableViewCell!

        cell?.recipeNameLabel.text = recipe.title
        cell?.recipeImageView.downloadedFrom(link: recipe.image)
        
        return cell!
    }
}
