//
//  ViewController.swift
//  SeeFood
//
//  Created by Aditya Karnam Gururaj Rao on 2/17/18.
//  Copyright © 2018 gotapi.umslhack. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import ImagePicker
import ToastSwiftFramework

class WatsonViewController: UIViewController {
    
    var visualRecognition: VisualRecognition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        visualRecognition = VisualRecognition(apiKey: AppConst.IBM_WATSON_KEY, version: AppConst.IBM_WATSON_VERSION)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self as ImagePickerDelegate
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension WatsonViewController : ImagePickerDelegate {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        let compressData = UIImageJPEGRepresentation(images[0], 0.5) //max value is 1.0 and minimum is 0.0
        let compressedImage = UIImage(data: compressData!)
        if let data = UIImagePNGRepresentation(compressedImage!) {
            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
            try? data.write(to: filename)
            let failure = { (error: Error) in print(error) }
            visualRecognition.classify(imageFile: filename.absoluteURL, failure: failure) { classifiedImages in
                print(classifiedImages)
                //self.view.makeToast(classifiedImages)
            }
            
        }
    }
}
