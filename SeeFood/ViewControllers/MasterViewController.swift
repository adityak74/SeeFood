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
    }
    
    func presentWatsonViewController() {
        
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

