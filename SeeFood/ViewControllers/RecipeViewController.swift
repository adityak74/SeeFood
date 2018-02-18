import UIKit

// Where the table/collection view will happen

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let ingredients: [String] = ["tomato", "onion", "eggs", "mushroom"]
    var recipies: [Recipe] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("nofr : ",self.recipies.count)
        return self.recipies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "recipeInfoSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cur recipe : ", indexPath.row)
        let recipe = self.recipies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeTableViewCell!
//        cell!.textCell?.text = workout?.title
//        cell!.backgroundColor = workout?.color
//        cell!.countLabel.text = "\(indexPath.row+1)"
//        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        //cell!.recipeNameLabel.text = recipe.title
        cell?.recipeNameLabel.text = recipe.title
        cell?.recipeImageView.downloadedFrom(link: recipe.image)
        return cell!
    }
    
    let rapidService = RapidService()
    
    @IBOutlet weak var recipeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        rapidService.getRecipes(from: ingredients) { (resultRecipies) in
            self.recipies = resultRecipies!
            DispatchQueue.main.async {
                print("Got Recipies : ", self.recipies.count)
                self.recipeTableView.reloadData()
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeInfoSegue" {
            if let indexPath = recipeTableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let detailVC = segue.destination as! RecipeInfoViewController
                detailVC.selectedRecipe = self.recipies[selectedRow]
            }
        }
    }
    
}

//NOTE:- Link RecipeViewController to Recipes.storyboard in interface builder

