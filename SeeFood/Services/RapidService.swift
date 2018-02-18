import Foundation

class RapidService {
    let serviceClient = BaseService()
    
    /*
    Ex: apples%2Cflour%2Csugar%2Cpine%20nuts
    --> %2C to separate ingredients
    --> %20 for spaces
    */
    
    func getRecipes(from ingredients: [String], completion: @escaping (_ recipe: Recipe?) -> ()) {
        //MARK:- Instantiate Path
        var path = AppConst.rapidBaseURL
        
        //MARK:- Append Path Components
        for ingredient in ingredients {
            if (ingredient.contains(" ")) {
                var temp = ingredient
                if let space = temp.range(of: " ") {
                    temp.replaceSubrange(space, with: "%20")
                }
                
                path.append("\(temp)%2C")
            }  else {
                path.append("\(ingredient)%2C")
            }
        }
        
        //MARK:- Perform GET Query
        serviceClient.get(from: URL(string: path)!, httpHeaders: AppConst.RAPID_HEADER, queryParams: nil) { (result) in
            switch result {
            case .success(let json):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let parsedJson = try decoder.decode(Recipe.self, from: json as! Data)
                    completion(parsedJson)
                } catch let jsonError {
                    print("Error serializing json:", jsonError)
                    completion(nil)
                    return
                }
            case .error(let error):
                Log.error(error)
                completion(nil)
            }
        }
    }
    
    
}
