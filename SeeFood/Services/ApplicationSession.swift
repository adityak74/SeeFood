import Foundation
import VisualRecognitionV3

class ApplicationSession {
    
    //MARK:- Vars
    let rapidService: RapidService
    var visualRecognition: VisualRecognition
    
    init() {
        self.rapidService = RapidService()
        self.visualRecognition = VisualRecognition(apiKey: AppConst.IBM_WATSON_KEY, version: AppConst.IBM_WATSON_VERSION)
    }
    
}
