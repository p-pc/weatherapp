//
//  OWMSelectCityViewController.swift
//  Open Weather Map
//
//  Created by Parthiban on 12/26/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import UIKit

class OWMSelectCityViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cityListTableView: UITableView!
    
    var cityResults = OWMCityListModel()
    
    var selectedCity : OWMCityItemModel?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.title = "Cities"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        
        self.cityListTableView.reloadData()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard self.selectedCity != nil else {return}
        
        if segue.identifier == "OWMCityWeatherViewControllerSegue" {
            
            let cityWeatherVC = segue.destination as! OWMCityWeatherViewController
            
            cityWeatherVC.cityModel = self.selectedCity
        }
        
        super.prepare(for: segue, sender: sender)

    }

}

extension OWMSelectCityViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchTextRaw: String) {
        
        if !Reachability.forInternetConnection().isReachable() {
            
            let alert = UIAlertController(title: "", message: "Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(alertActionOK)

            DispatchQueue.main.async {
                
                self.present(alert, animated: true, completion: nil)
                
                return
                
            }

        }
        
        let charSet : NSMutableCharacterSet = NSMutableCharacterSet()
        charSet.formUnion(with: CharacterSet.uppercaseLetters)
        charSet.formUnion(with: CharacterSet.lowercaseLetters)
        charSet.formUnion(with: CharacterSet.whitespaces)
        
        let searchText = searchTextRaw.trimmingCharacters(in: charSet.inverted)

        searchBar.text = searchText
        
        if searchText == "" {
            
            self.cityResults = OWMCityListModel()
            
            DispatchQueue.main.async {

                self.refreshData()

                return
                
            }
            
        }
        
        OWMServiceManager.sharedInstance.getCitiesFor(searchText: searchText, completion: { error,response in
            
            func onSuccess(response: OWMCityListModel) {
                
                self.cityResults = response
                
                DispatchQueue.main.async {

                    self.refreshData()
                    
                }
            }
            
            func onFailure(error: Error) {
                
                self.cityResults = OWMCityListModel()
                
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)

                let alertActionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
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
}

extension OWMSelectCityViewController : UITableViewDataSource, UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cityResults.cityList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cityItem = self.cityResults.cityList[indexPath.row]
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OWMCityTableViewCellIdentifier", for: indexPath)
        
        cell.textLabel?.text = cityItem.cityDisplayName
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cityItem = self.cityResults.cityList[indexPath.row]

        self.selectedCity = cityItem
        
        self.performSegue(withIdentifier: "OWMCityWeatherViewControllerSegue", sender: nil)
    }

}
