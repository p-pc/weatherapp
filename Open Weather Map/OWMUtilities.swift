//
//  OWMUtilities.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/26/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit


class OWMUtilities: NSObject {


    class func citySearchURLFor(text : String) -> URL? {
        
        guard let urlStr = OWMUtilities.getStringFor(key: "CitySearchURL") else {return nil}
        
        let encodedStr = text.replacingOccurrences(of: " ", with: "%20", options: [], range: nil)

        let strVal = String(format:urlStr, OWMConstants.citySearchAPIKey, encodedStr)
        
        guard let urlVal = URL(string:strVal) else {return nil}
        
        return urlVal
        
    }
    
    class func openWeatherURLFor(city : String) -> URL? {
        
        guard let urlStr = OWMUtilities.getStringFor(key: "OpenWeatherURL") else {return nil}
        
        let encodedStr = city.replacingOccurrences(of: " ", with: "%20", options: [], range: nil)
        
        let strVal = String(format:urlStr, encodedStr, OWMConstants.openWeatherAPPID)
        
        guard let urlVal = URL(string:strVal) else {return nil}
        
        return urlVal
        
    }

    class func iconURLFor(code : String) -> URL? {
        
        guard let urlStr = OWMUtilities.getStringFor(key: "IconURL") else {return nil}
        
        let encodedStr = code.replacingOccurrences(of: " ", with: "%20", options: [], range: nil)
        
        let strVal = String(format:urlStr, encodedStr)
        
        guard let urlVal = URL(string:strVal) else {return nil}
        
        return urlVal
        
    }

    class func getStringFor(key:String) -> String? {
        
        guard let path = Bundle.main.path(forResource: "Environment", ofType: "plist") else {return nil}
        
        guard let dict = NSDictionary(contentsOfFile: path) else {return nil}
        
        if let strVal = dict.value(forKey: key) as? String {
            return strVal
        }else{
            return nil
        }

    }
    
    class func updateRecentCitiesListWith(city : OWMCityItemModel) {
        
        let defaults = UserDefaults.standard
        
        func setInitDataWith(cityVal : OWMCityItemModel) {
            
            let recentCities = OWMCityListModel()
            
            recentCities.cityList.append(cityVal)
            
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: recentCities) as Data, forKey: "recentCities")
            
            defaults.synchronize()

        }
        
        if let data = defaults.object(forKey: "recentCities") as? Data {
            
            if let recentCities = NSKeyedUnarchiver.unarchiveObject(with: data) as? OWMCityListModel {
                
                for anItem in recentCities.cityList {
                    
                    if anItem.cityDisplayName == city.cityDisplayName {
                        
                        recentCities.cityList.remove(at: recentCities.cityList.index(of: anItem)!)
                        
                    }
                    
                }
                
                recentCities.cityList.insert(city, at: 0)
                
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: recentCities) as NSData, forKey: "recentCities")
                
                defaults.synchronize()

            }
            else {
                setInitDataWith(cityVal: city)
            }
            
        }
        else {
            
            setInitDataWith(cityVal: city)

        }
        
    }
    
    class func getRecentCitiesList() -> OWMCityListModel {
        
        var retVal = OWMCityListModel()
        
        let defaults = UserDefaults.standard

        if let data = defaults.object(forKey: "recentCities") as? Data {
            
            if let recentCities = NSKeyedUnarchiver.unarchiveObject(with: data) as? OWMCityListModel {
                
                retVal = recentCities
                
                return retVal

            }
            else {
                return retVal
            }
        }
        else {
            return retVal
        }
        
    }
    
}

struct OWMConstants {
    
    static let citySearchAPIKey = "AIzaSyBquitvUuulCMe2vKVPWYLeDlGVL5i7q5s"
    
    static let openWeatherAPPID = "ef54b73db906dde8e7c21c8231865944"

    static let AESKey = "s@mp1eOWM@pp"

}
