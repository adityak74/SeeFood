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

protocol WatsonViewControllerDelegate: class {
    func signalRapid(with keys: [String])
}

class WatsonViewController: UIViewController {
    
    var visualRecognition: VisualRecognition!
    var delegate: WatsonViewControllerDelegate?
    var imagePickerController: ImagePickerController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        visualRecognition = VisualRecognition(apiKey: AppConst.IBM_WATSON_KEY, version: AppConst.IBM_WATSON_VERSION)
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        imagePickerController = ImagePickerController()
//        imagePickerController.delegate = self as ImagePickerDelegate
//        self.present(imagePickerController, animated: true, completion: nil)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        imagePickerController = ImagePickerController()
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
        SwiftSpinner.show("Watson is looking through images...")
        
        let numImagesToRecognize = images.count
        var imagesRecognized = 0
        
        var possibleItemsList: [String] = []
        for image in images {
            let compressData = UIImageJPEGRepresentation(image, 0.5) //max value is 1.0 and minimum is 0.0
            let compressedImage = UIImage(data: compressData!)
            if let data = UIImagePNGRepresentation(compressedImage!) {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
                let failure = { (error: Error) in print(error) }
                visualRecognition.classify(imageFile: filename.absoluteURL, failure: failure) { classifiedImages in
                    
                    // Examine classes returned from Watson
                    for val in classifiedImages.images[0].classifiers[0].classes {
                        if AppConst.FOOD_LIST.contains(val.classification.lowercased()) && (val.score >= AppConst.VREC_MIN_ACCURACY) {
                            //print(val.classification.lowercased())
                            possibleItemsList.append(val.classification.lowercased())
                        }
                    }
                    
                    imagesRecognized += 1
                    //print("possibleItemsList : ", possibleItemsList)
                    //print(classifiedImages.images[0].classifiers[0].classes[0].classification, classifiedImages.images[0].classifiers[0].classes[0].score)
                    //self.view.makeToast(classifiedImages)
                    if (imagesRecognized == numImagesToRecognize) {
                        SwiftSpinner.hide()
                        // Segue to the new controller
                        DispatchQueue.main.async {
                            
                            self.delegate?.signalRapid(with: possibleItemsList)
//                            self.imagePickerController.collapseGalleryView({
//                                self.delegate?.signalRapid(with: possibleItemsList)
//                            })
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
}
