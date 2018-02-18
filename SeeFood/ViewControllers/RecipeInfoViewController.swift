//
//  RecipeInfoViewController.swift
//  SeeFood
//
//  Created by Aditya Karnam Gururaj Rao on 2/18/18.
//  Copyright © 2018 gotapi.umslhack. All rights reserved.
//

import UIKit

class RecipeInfoViewController: UIViewController {

    let rapidService = RapidService()
    @IBOutlet weak var recipeTitle: UINavigationItem!
    var selectedRecipe: Recipe!
    @IBOutlet weak var recipeInstructions: UITextView!
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
