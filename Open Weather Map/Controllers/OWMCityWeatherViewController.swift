//
//  OWMCityWeatherViewController.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/27/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit

class OWMCityWeatherViewController: UIViewController {

    var cityModel : OWMCityItemModel?
    
    var weatherData : OWMWeatherModel?
    
    override func viewDidLoad() {
      
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        guard let city = cityModel else {return}
        
        self.title = city.cityName
        
        self.refreshDataForCity()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func refreshDataForCity() {
        
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertActionOK)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }
        
        guard let cityName = self.cityModel?.cityName else {return}
        
        OWMServiceManager.sharedInstance.getWeatherFor(city: cityName, completion: { error,response in
            
            func onSuccess(response: OWMWeatherModel) {
                
                self.weatherData = response
                
                DispatchQueue.main.async {
                    
                    self.refreshData()
                    
                }
            }
            
            func onFailure(error: Error) {
                
                self.weatherData = nil
                
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) -> Void in
                    
                    self.navigationController?.popViewController(animated: true)
                    
                })
                
                alert.addAction(alertActionOK)
                
                DispatchQueue.main.async {
                    
                    self.refreshData()
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            if let err = error {
                
                onFailure(error: err)
                
            }
            else {
                
                guard let respData = response else {
                    
                    onFailure(error: NSError(domain:"", code:-1, userInfo:["localizedDescription":"Something went wrong"]))
                    
                    return
                }
                
                onSuccess(response: respData)
            }

        })
        
    }
    
    func refreshData() {
        
        //refresh view data
        if let data = self.weatherData {
            //set values to UI components
            DispatchQueue.main.async {
                print("data : \(data)")
            }
            
        }
        else {
            //clear UI - pop to previous screen in alert
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
