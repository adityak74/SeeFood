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
    }
    
    func presentView() {
        /*
         Ex: if(!persistence_exists) {
            presentRecipeViewController()
         } else {
            presentWatsonViewController()
         }
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

