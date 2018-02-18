import UIKit

class MasterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentView()
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        presentView()
        //NOTE:- We may not end up using this
    }
    
    func presentView() {
        /*
         Ex: if(!persistence_exists) {
            presentRecipeViewController()
         } else {
            presentWatsonViewController()
         }
         
         NOTE:- You will need dismissals when you set up segues (not in this function)
        */
        
        presentWatsonViewController()

        
    }
    
    func presentWatsonViewController() {
        let watsonStoryboard = UIStoryboard(name: "Watson", bundle: Bundle.main)
        guard let watsonVC = watsonStoryboard.instantiateInitialViewController() as? WatsonViewController else {
            print("Failed WatsonViewController INIT")
            return
        }
        
        //NOTE:- PASS ANYTHING TO DO W/ MODEL
        
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
            let _ = targetNavigationVC.childViewControllers.first as? RecipeViewController else {
                print("Failed RecipeViewController INIT")
                return
        }
        
        //NOTE:- change _ = targetNavigat... to targetVC =
        //targetVC model
        //targetVC.tableview delegate
        //targetVC.tableview data source
        
        transitionControllers(targetNavigationVC: targetNavigationVC)
    }
    
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

