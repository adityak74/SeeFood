import UIKit
import ImagePicker

//MARK:- Protocols
protocol WatsonViewControllerDelegate: class {
    func processImages(with images: [UIImage])
}

class WatsonViewController: UIViewController, ImagePickerDelegate {
    
    //MARK:- Vars
    var delegate: WatsonViewControllerDelegate?
    var imagePickerController: ImagePickerController! = nil
    
    //MARK:- ViewController Logic
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imagePickerController = ImagePickerController()
        imagePickerController.delegate = self as ImagePickerDelegate
        self.present(imagePickerController, animated: true, completion: nil)
    }

    //MARK:- ImagePickerDelegate
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        delegate?.processImages(with: images)
    }
}

extension WatsonViewController: MasterModelWatsonDelegate {
    
    func getFileName() -> URL {
        return getDocumentsDirectory().appendingPathComponent("copy.png")
    }
}
