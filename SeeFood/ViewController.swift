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

class ViewController: UIViewController {
    
    var visualRecognition: VisualRecognition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let apiKey = "8e5631d0af2900db0920cbdfcdbac8366b75260a"
        let version = "2018-02-17" // use today's date for the most recent version
        visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
//        let url = "https://farm4.staticflickr.com/3754/11702702564_1fc3c669ba_m.jpg"
//        let failure = { (error: Error) in print(error) }
//        visualRecognition.classify(image: url, failure: failure) { classifiedImages in
//            print(classifiedImages)
//        }
        
        
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

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}

extension ViewController : ImagePickerDelegate {
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

