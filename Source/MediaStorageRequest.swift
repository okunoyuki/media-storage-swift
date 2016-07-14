//
//  Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
//  See LICENSE for more information
//

import Foundation

class MediaStorageRequest {
    static func get(url url: String, queryParams: Dictionary<String, String>, header: Dictionary<String, String>, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        var requestUrl = url
        if queryParams.count > 0 {
            requestUrl += "?" + joinParameters(params: queryParams)
        }
        sendRequest(
            url: requestUrl,
            method: "GET",
            header: header,
            params: [String: String](),
            completionHandler: completionHandler
        )
    }
    
    static func post(url url: String, header: Dictionary<String, String>, params: Dictionary<String, String>, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequest(
            url: url,
            method: "POST",
            header: header,
            params: params,
            completionHandler: completionHandler
        )
    }
    
    static func put(url url: String, header: Dictionary<String, String>, data: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void){
        sendRequest(
            url: url,
            method: "PUT",
            header: header,
            data: data,
            completionHandler: completionHandler
        )
    }
    
    static func upload(url url: String, header: Dictionary<String, String>, data: NSData, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequestToUpload(
            url: url,
            method: "POST",
            header: header,
            data: data,
            completionHandler: completionHandler
        )
    }
    
    static func download(url url: String, header: Dictionary<String, String>, completionHandler: (NSURL?, NSURLResponse?, NSError?) -> Void) {
        sendRequestToDownload(
            url: url,
            method: "GET",
            header: header,
            completionHandler: completionHandler
        )
    }
    
    static func delete(url url: String, header: Dictionary<String, String>, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        sendRequest(
            url: url,
            method: "DELETE",
            header: header,
            params: [String: String](),
            completionHandler: completionHandler
        )
    }
    
    static func sendRequest(url url: String, method: String, header: Dictionary<String, String>, params: Dictionary<String, String>? = nil, data: String? = nil, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = generateRequest(url: url, method: method, header: header, params: params, data: data)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    static func sendRequestToUpload(url url: String, method: String, header: Dictionary<String, String>, data: NSData, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = generateRequest(url: url, method: method, header: header, params: [String: String]())
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler: completionHandler)
        task.resume()
    }
    
    static func sendRequestToDownload(url url: String, method: String, header: Dictionary<String, String>, completionHandler: (NSURL?, NSURLResponse?, NSError?) -> Void) {
        let request = generateRequest(url: url, method: method, header: header, params: [String: String]())
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.downloadTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    static func generateRequest(url url: String, method: String, header: Dictionary<String, String>, params: Dictionary<String, String>? = nil, data: String? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if params != nil {
            request.HTTPBody = joinParameters(params: params!).dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        if data != nil {
            request.HTTPBody = data!.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        return request
    }
    
    static func joinParameters(params params: Dictionary<String, String>) -> String {
        return params.map({(key, value) in
            return "\(key)=\(value)"
        }).joinWithSeparator("&")
    }
}
