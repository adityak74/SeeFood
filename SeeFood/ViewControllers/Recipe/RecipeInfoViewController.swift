import UIKit

class RecipeInfoViewController: UIViewController {
    
    //MARK:- Vars
    var instructionsText: String?
    
    //MARK:- Outlets
    @IBOutlet weak var instructions: UITextView!
    
    //MARK:- ViewController Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        instructions.text = instructionsText
    }
}
