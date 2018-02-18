import Foundation

typealias ServiceCallCompletion = (_ result: ServiceCallResult) -> ()

struct ServiceCallError {
    let message: String
    let code: Int?
}

enum ServiceCallResult {
    case success(result: Any)
    case error(error: ServiceCallError)
}

enum RequestBodyContentType: String {
    case json = "application/json; charset=utf-8"
}

enum ServiceCallMethod: String {
    case get = "GET"
    case post = "POST"
}

class BaseService {
    
    func get(from endpoint: URL,
             httpHeaders: [String:String],
             queryParams:[String:String]?,
             completion: @escaping ServiceCallCompletion) {
        
        let completeUrlPath = appendQueryParams(to: endpoint, queryParams: queryParams)
        
        // Create URL
        guard let completeUrl = URL(string: completeUrlPath) else {
            let serviceCallError = ServiceCallError(message: "Error constructing URL for service call", code: nil)
            Log.error(serviceCallError.message)
            completion(ServiceCallResult.error(error: serviceCallError))
            return
        }
        
        let request = prepareUrlRequestAndSetHttpHeaders(to: completeUrl, httpMethod: ServiceCallMethod.get, httpHeaders: httpHeaders)
        
        Log.info("🌎 GET: \(completeUrl.absoluteString)")
        
        // Create the URL Session and the task to perform
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.responseHandler(completion: completion, data: data, response: response, error: error)
        }
        
        // Start the task
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    func post(to endpoint: URL,
              httpHeaders: [String:String],
              httpBody: Data?,
              queryParams:[String:String]?,
              completion: @escaping ServiceCallCompletion) {
        
        let completeUrlPath = appendQueryParams(to: endpoint, queryParams: queryParams)
        
        guard let completeUrl = URL(string: completeUrlPath) else {
            let serviceCallError = ServiceCallError(message: "Error constructing URL for service call", code: nil)
            Log.error(serviceCallError.message)
            completion(ServiceCallResult.error(error: serviceCallError))
            return
        }
        
        var request = prepareUrlRequestAndSetHttpHeaders(to: completeUrl, httpMethod: ServiceCallMethod.post, httpHeaders: httpHeaders)
        request.setValue(RequestBodyContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        //        Log.info("🌎 POST: \(endpoint.path) with body: \(String(data: httpBody, encoding: .utf8) ?? "No Body Data")")
        
        // Create the URL Session and the task to perform
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            self?.responseHandler(completion: completion, data: data, response: response, error: error)
        }
        
        // Start the task
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    private func appendQueryParams(to endpoint: URL, queryParams:[String:String]?) -> String {
        var completeUrlPath = endpoint.absoluteString
        
        // Append query params, if present
        if let params = queryParams {
            let parameterString = params.map { "\($0.key)=\($0.value)" } .joined(separator: "&")
            completeUrlPath.append("?\(parameterString)")
        }
        
        return completeUrlPath
    }
    
    private func prepareUrlRequestAndSetHttpHeaders(to url: URL, httpMethod: ServiceCallMethod, timeoutInterval: Double = 10.0, httpHeaders:[String:String]) -> URLRequest {
        // Create the URL Request
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = timeoutInterval
        
        // Set headers on the URL Request
        for (key, value) in httpHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    private func responseHandler(completion: @escaping ServiceCallCompletion, data: Data?, response: URLResponse?, error: Error?) {
        // Check for errors
        if let responseError = error {
            let serviceCallError = ServiceCallError(message: responseError.localizedDescription, code: nil)
            completion(ServiceCallResult.error(error: serviceCallError))
            return
        }
        
        // Check if we can parse response
        guard let httpResponse = response as? HTTPURLResponse else {
            let serviceCallError = ServiceCallError(message: "Could not parse HTTP response", code: nil)
            completion(ServiceCallResult.error(error: serviceCallError))
            return
        }
        
        Log.info("🌎 [Code]: \(httpResponse.statusCode)")
        
        // Check for response codes outside of 200s (success range)
        if !(200 ... 299 ~= httpResponse.statusCode) {
            let serviceCallError = ServiceCallError(message: "Unsuccessful service call", code: httpResponse.statusCode)
            completion(ServiceCallResult.error(error: serviceCallError))
            return
        }
        
        if let responseData = data {
            Log.info(String(data: responseData, encoding: .utf8)!)
            completion(ServiceCallResult.success(result: responseData))
            return
        }
        
        completion(ServiceCallResult.success(result: []))
    }
}
