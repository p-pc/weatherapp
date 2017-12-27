//
//  OWMWeatherModel.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/27/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit

class OWMWeatherModel: NSObject {

    override init() {
        
    }
    
    required convenience init?(jsonData : NSDictionary){
        
        self.init()
     
        print("jsonData : \(jsonData)")
        
    }
}
