//
//  OWMServiceManager.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/26/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit
import Alamofire

class OWMServiceManager: NSObject {

    static let sharedInstance: OWMServiceManager = {
        
        let instance = OWMServiceManager()
        
        return instance
        
    }()

    func getCitiesFor(searchText : String, completion:@escaping (Error?, OWMCityListModel?) ->Void) {
        
        var err:Error?

        guard let url = OWMUtilities.citySearchURLFor(text: searchText) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
            print("response : \(response.result)")
            print("response : \(String(describing: response.response))")
            
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,nil)
                    
                    return
                    
                }
                
                do {
                    guard let parsedObject : NSDictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary else {return}
                    
                    let model = OWMCityListModel(jsonData: parsedObject)
        
                    completion(nil, model)
                    
                }
                catch {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid JSON"])
                    
                    completion(err,nil)
                    
                }

            case .failure(let errVal):
                
                err = NSError(domain:"", code:-1, userInfo:["localizedDescription":errVal.localizedDescription])
                
                completion(errVal,nil)
            }
            
        })
        
        
        
        
    }
}