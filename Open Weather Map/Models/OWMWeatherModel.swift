//
//  OWMWeatherModel.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/27/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit

class OWMWeatherModel: NSObject {

    var coord_lon : String = "NA"
    var coord_lat : String = "NA"
    var weather_id : String = "NA"
    var weather_main : String = "NA"
    var weather_description : String = "NA"
    var weather_icon : String = "NA"
    var base : String = "NA"
    var main_temp : String = "NA"
    var main_pressure : String = "NA"
    var main_humidity : String = "NA"
    var main_temp_min : String = "NA"
    var main_temp_max : String = "NA"
    var visibility : String = "NA"
    var wind_speed : String = "NA"
    var wind_deg : String = "NA"
    var clouds_all : String = "NA"
    var dt : String = "NA"
    var sys_type : String = "NA"
    var sys_id : String = "NA"
    var sys_message : String = "NA"
    var sys_country : String = "NA"
    var sys_sunrise : String = "NA"
    var sys_sunrise_time : Date?
    var sys_sunset : String = "NA"
    var sys_sunset_time : Date?
    var id : String = "NA"
    var name : String = "NA"
    var cod : String = "NA"

    override init() {
        
    }
    
    required convenience init?(jsonData : NSDictionary){
        
        self.init()
        
        if let dict = jsonData["coord"] as? Dictionary<String,Any>, let val = dict["lon"] as? Double {
            self.coord_lon = "\(val)"
        }
        
        if let dict = jsonData["coord"] as? Dictionary<String,Any>, let val = dict["lat"] as? Double {
            self.coord_lat = "\(val)"
        }
        
        if let arr = jsonData["weather"] as? Array<Dictionary<String,Any>> {
            if let obj = arr.first {
                if let val = obj["main"] as? String {
                    self.weather_main = val
                }
                if let val = obj["icon"] as? String {
                    self.weather_icon = val
                }
                if let val = obj["description"] as? String {
                    self.weather_description = val
                }
                if let val = obj["id"] as? Int {
                    self.weather_id = "\(val)"
                }

            }
        }

        if let val = jsonData["base"] as? String {
            self.base = val
        }
        
        if let dict = jsonData["main"] as? Dictionary<String,Any>, let val = dict["temp"] as? Double {
            self.main_temp = "\(val)"
        }

        if let dict = jsonData["main"] as? Dictionary<String,Any>, let val = dict["pressure"] as? Int {
            self.main_pressure = "\(val)"
        }

        if let dict = jsonData["main"] as? Dictionary<String,Any>, let val = dict["humidity"] as? Int {
            self.main_humidity = "\(val)"
        }

        if let dict = jsonData["main"] as? Dictionary<String,Any>, let val = dict["temp_min"] as? Double {
            self.main_temp_min = "\(val)"
        }

        if let dict = jsonData["main"] as? Dictionary<String,Any>, let val = dict["temp_max"] as? Double {
            self.main_temp_max = "\(val)"
        }

        if let val = jsonData["visibility"] as? Int {
            self.visibility = "\(val)"
        }

        if let dict = jsonData["wind"] as? Dictionary<String,Any>, let val = dict["speed"] as? Double {
            self.wind_speed = "\(val)"
        }

        if let dict = jsonData["wind"] as? Dictionary<String,Any>, let val = dict["deg"] as? Double {
            self.wind_deg = "\(val)"
        }

        if let dict = jsonData["clouds"] as? Dictionary<String,Any>, let val = dict["all"] as? Int {
            self.clouds_all = "\(val)"
        }

        if let val = jsonData["dt"] as? Int {
            self.dt = "\(val)"
        }

        if let dict = jsonData["sys"] as? Dictionary<String,Any>, let val = dict["type"] as? Int {
            self.sys_type = "\(val)"
        }

        if let dict = jsonData["sys"] as? Dictionary<String,Any>, let val = dict["id"] as? Int {
            self.sys_id = "\(val)"
        }

        if let dict = jsonData["sys"] as? Dictionary<String,Any>, let val = dict["message"] as? Double {
            self.sys_message = "\(val)"
        }

        if let dict = jsonData["sys"] as? Dictionary<String,Any>, let val = dict["country"] as? String {
            self.sys_country = val
        }
        
        if let dict = jsonData["sys"] as? Dictionary<String,Any>, let val = dict["sunrise"] as? Int {
            self.sys_sunrise = "\(val)"
            self.sys_sunrise_time = NSDate(timeIntervalSince1970: TimeInterval(val)) as Date
        }

        if let dict = jsonData["sys"] as? Dictionary<String,Any>, let val = dict["sunset"] as? Int {
            self.sys_sunset = "\(val)"
            self.sys_sunset_time = NSDate(timeIntervalSince1970: TimeInterval(val)) as Date
        }
        
        if let val = jsonData["id"] as? Int {
            self.id = "\(val)"
        }

        if let val = jsonData["name"] as? String {
            self.name = val
        }
        
        if let val = jsonData["cod"] as? Int {
            self.cod = "\(val)"
        }
        
    }
}
