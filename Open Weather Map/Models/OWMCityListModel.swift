//
//  OWMCityListModel.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/26/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit

class OWMCityListModel: NSObject, NSCoding {
    
    var cityList = Array<OWMCityItemModel>()
    
    override init() {
        
    }

    required convenience init?(jsonData : NSDictionary){
        
        self.init()
        
        guard let status = jsonData["status"] as? String else {return}
        
        if status != "OK" {
            return
        }
        
        if let predArr = jsonData["predictions"] as? NSArray {
            
            self.cityList = Array<OWMCityItemModel>()
            
            for anItem in predArr {
                
                guard let anItemDict = anItem as? Dictionary<String,AnyObject> else {continue}
                
                guard let cityNameVal = anItemDict["structured_formatting"]!["main_text"] as? String else {continue}
                
                guard let cityDescVal = anItemDict["description"] as? String else {continue}
                
                guard let cityItem = OWMCityItemModel(cityNameVal: cityNameVal, cityDisplayNameVal: cityDescVal) else {continue}
                
                self.cityList.append(cityItem)
                
            }
        }
    }
    
    required convenience init?(coder decoder: NSCoder){
        self.init()
        self.cityList = decoder.decodeObject(forKey: "cityList") as! Array<OWMCityItemModel>
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.cityList, forKey: "cityList")
    }

}

class OWMCityItemModel: NSObject, NSCoding {
    
    var cityName = ""
    
    var cityDisplayName = ""
    
    override init() {
        
    }
    
    required convenience init?(cityNameVal : String, cityDisplayNameVal : String){
        
        self.init()
        
        self.cityName = cityNameVal
        
        self.cityDisplayName = cityDisplayNameVal
        
    }
    
    required convenience init?(coder decoder: NSCoder){
        self.init()
        self.cityName = decoder.decodeObject(forKey: "cityName") as! String
        self.cityDisplayName = decoder.decodeObject(forKey: "cityDisplayName") as! String
    }
    
    func encode(with coder: NSCoder){
        coder.encode(self.cityName, forKey: "cityName")
        coder.encode(self.cityDisplayName, forKey: "cityDisplayName")
    }
    
}
