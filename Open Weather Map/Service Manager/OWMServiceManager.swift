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
        
        //Comment : Google's Places Autocomplete API used becasue Open Weather's city list did not contain state information for cities with same name - restricted city search to US only - API restriction to give 5 results only at a time
        var err:Error?

        guard let url = OWMUtilities.citySearchURLFor(text: searchText) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
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
    
    func getWeatherFor(city : String, completion:@escaping (Error?, OWMWeatherModel?) ->Void) {
        
        //Comment : Open Weather's city list did not contain state information for cities with same name - so results are not accurate - this can be handled properly if a mapping for id is established in http://bulk.openweathermap.org/sample/city.list.json.gz

        var err:Error?
        
        guard let url = OWMUtilities.openWeatherURLFor(city: city) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        Alamofire.request(url).responseJSON(completionHandler: { response in
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,nil)
                    
                    return
                    
                }
                
                do {
                    guard let parsedObject : NSDictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions()) as? NSDictionary else {return}
                    
                    let model = OWMWeatherModel(jsonData: parsedObject)
                    
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
    
    func getImageDataFor(icon : String, completion:@escaping (Error?, Data?) ->Void) {
        
        //Comment : Images can be cached using cachae managers like Kingfisher - so same images don't get downloaded again and picked from cache
        var err:Error?
        
        guard let url = OWMUtilities.iconURLFor(code: icon) else {
            
            err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid URL"])
            
            completion(err,nil)
            
            return
            
        }
        
        Alamofire.request(url).responseData(completionHandler: { response in
            
            switch response.result {
                
            case .success:
                
                guard response.data != nil else {
                    
                    err = NSError(domain:"", code:-1, userInfo:["localizedDescription":"Invalid Data"])
                    
                    completion(err,nil)
                    
                    return
                    
                }
                
                completion(nil,response.data)
                
            case .failure(let errVal):
                
                err = NSError(domain:"", code:-1, userInfo:["localizedDescription":errVal.localizedDescription])
                
                completion(errVal,nil)
            }
            
        })
        
    }


}
