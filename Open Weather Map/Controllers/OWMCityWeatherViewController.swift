//
//  OWMCityWeatherViewController.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/27/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit

class OWMCityWeatherViewController: UIViewController {

    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblWeatherMain: UILabel!
    @IBOutlet weak var lblMainTemp: UILabel!
    @IBOutlet weak var lblmainTempMin: UILabel!
    @IBOutlet weak var lblmainTempMax: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblSunriseTime: UILabel!
    @IBOutlet weak var lblSunsetTime: UILabel!
    
    var cityModel : OWMCityItemModel?
    
    var weatherData : OWMWeatherModel?
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        self.refreshData()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        
        guard let city = cityModel else {return}
        
        self.title = city.cityName
        
        //Comment : fetch data for selected city automatically - not archived as it needs to be fresh always
        self.refreshDataForCity()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    func refreshDataForCity() {
        
        //Comment : check network status and return if data unavailable
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) -> Void in
                
                DispatchQueue.main.async {
                
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
            })

            alert.addAction(alertActionOK)
            
            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }
            
        }
        
        guard let cityName = self.cityModel?.cityName else {return}
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        OWMServiceManager.sharedInstance.getWeatherFor(city: cityName, completion: { error,response in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
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
                    
                    DispatchQueue.main.async {
                        
                        //Comment : alert the user and return to previous screen
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
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
        
        //Comment : very crude handling of UI refresh - can be made as a scrollable view with more presentable data - proper unit conversions can be added for metric/imperial & C/F scales
        if let data = self.weatherData {
            
            //Comment : handle UI refreshes in main thread to ensure proper UI updates
            DispatchQueue.main.async {
                
                self.lblWeatherMain.text = "Weather : \(data.weather_main)"
                self.lblMainTemp.text = "Temp : \(data.main_temp)"
                self.lblmainTempMin.text = "Min. Temp : \(data.main_temp_min)"
                self.lblmainTempMax.text = "Max. Temp : \(data.main_temp_max)"
                self.lblWindSpeed.text = "Wind : \(data.wind_speed)"
                if let time = data.sys_sunrise_time {
                    self.lblSunriseTime.text = "Sunrise : \(time)"
                }
                if let time = data.sys_sunset_time {
                    self.lblSunsetTime.text = "Sunset : \(time)"
                }
                
                self.updateImageWith(icon : data.weather_icon)

            }
            
        }
        else {
            self.lblWeatherMain.text = "Weather : NA"
            self.lblMainTemp.text = "Temp : NA"
            self.lblmainTempMin.text = "Min. Temp : NA"
            self.lblmainTempMax.text = "Max. Temp : NA"
            self.lblWindSpeed.text = "Wind : NA"
            self.lblSunriseTime.text = "Sunrise : NA"
            self.lblSunsetTime.text = "Sunset : NA"
        }
        
    }
    
    func updateImageWith(icon : String) {
        
        //Comment : used status bar indicator for time being - can have an activity indicator in UI too
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        //Comment : Images can be cached using cachae managers like Kingfisher - so same images don't get downloaded again and picked from cache
        OWMServiceManager.sharedInstance.getImageDataFor(icon: icon, completion: { error, data in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            func onSuccess(response: Data) {
                
                DispatchQueue.main.async {
                    
                    guard let img = UIImage(data: response) else {return}
                    
                    self.imgViewIcon.image = img
                    
                }
            }

            func onFailure(error: Error) {
                
                //Comment : do nothing - leave the default image
            }

            if let err = error {
                
                onFailure(error: err)
                
            }
            else {
                
                guard let respData = data else {
                    
                    onFailure(error: NSError(domain:"", code:-1, userInfo:["localizedDescription":"Something went wrong"]))
                    
                    return
                }
                
                onSuccess(response: respData)
            }

            
        })
        
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
