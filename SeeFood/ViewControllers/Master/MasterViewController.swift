import UIKit

class MasterViewController: UIViewController {
    
    //MARK:- Vars
    private var model: MasterModel?
    private var presentWatson: Bool?
    
    //MARK:- ViewController Logic
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = MasterModel()
        self.model?.masterDelegate = self
        self.presentWatson = true   //NOTE:- Will change when persistence supported
        presentView()
    }
    
    func setBool(with state: Bool) {
        self.presentWatson = state
    }
    
    //MARK:- ViewController Presentations Logic
    func presentView() {
        if (presentWatson)! {
            presentWatsonViewController()
        } else {
            presentRecipeViewController()
        }
    }
    
    func presentWatsonViewController() {
        let watsonStoryboard = UIStoryboard(name: "Watson", bundle: Bundle.main)
        guard let watsonVC = watsonStoryboard.instantiateInitialViewController() as? WatsonViewController else {
            print("🤢 Failed WatsonViewController INIT")
            return
        }
        
        self.model?.watsonDelegate = watsonVC
        watsonVC.delegate = self
        
        if let currentVC = childViewControllers.first, currentVC !== watsonVC {
            transition(from: currentVC, to: watsonVC, duration: 1.5, setup: {
                watsonVC.view.alpha = 0.0
            }, animation: {
                watsonVC.view.alpha = 1.0
                currentVC.view.alpha = 0.0
            })
        } else {
            addFullScreen(controller: watsonVC, animationDuration: 0.5, setup: {
                watsonVC.view.alpha = 0.0
            }, animation: {
                watsonVC.view.alpha = 1.0
            })
        }
    }
    
    func presentRecipeViewController() {
        let targetStoryboard = UIStoryboard(name: "Recipes", bundle: Bundle.main)
        guard let targetNavigationVC = targetStoryboard.instantiateInitialViewController() as? UINavigationController,
            let targetVC = targetNavigationVC.childViewControllers.first as? RecipeViewController else {
                print("🤢 Failed RecipeViewController INIT")
                return
        }
        
        self.model?.recipeDelegate = targetVC
        targetVC.delegate = self
        transitionControllers(targetNavigationVC: targetNavigationVC)
    }
    
    func dismissViewController(with state: Bool) {
        setBool(with: state)
        self.dismiss(animated: true, completion: nil)
        presentView()
    }
    
    //MARK:- Transitions
    func transitionControllers(targetNavigationVC: UINavigationController) {
        if let watsonVC = childViewControllers.first as? WatsonViewController {
            transition(from: watsonVC, to: targetNavigationVC, duration: 1.5, setup: {
                targetNavigationVC.view.alpha = 0.0
            }, animation: {
                targetNavigationVC.view.alpha = 1.0
                watsonVC.view.alpha = 0.0
            })
        } else {
            addFullScreen(controller: targetNavigationVC, animationDuration: 0.5, setup: {
                targetNavigationVC.view.alpha = 0.0
            }, animation: {
                targetNavigationVC.view.alpha = 1.0
            })
        }
    }
}

//MARK:- Delegates
extension MasterViewController: MasterModelDelegate {
    
    func dismissWatson() {
        dismissViewController(with: false)
    }
}

extension MasterViewController: WatsonViewControllerDelegate {

    func processImages(with images: [UIImage]) {
        model?.pingWatson(with: images)
    }
}

extension MasterViewController: RecipeViewControllerDelegate {
    
    func clearAll() {
        model?.clearAll()
        dismissViewController(with: true)
    }
    
    func addIngredients() {
        dismissViewController(with: true)
    }
    
    func setCurrentRecipes() {
        model?.setRecipes()
    }
    
    func getCurrentRecipes() -> [Recipe] {
        return (model?.getRecipes())!
    }
    
    func getSelectedRecipeInstructions(from index: Int) {
        model?.getRecipeInstructions(from: index)
    }
}

