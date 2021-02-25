//
//  OtherCitiesTableViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 23/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class OtherCitiesTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let weatherDataModel = WeatherDataModel()
    let locationManager = CLLocationManager()
    
    var cityName = [String]()
    var temp = [Int]()
    var icon = [String]()
    
    let nearestCityamount = "10"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        warningPopUP(withTitle: "Weather forecast", withMessage: "Here you will find weather forecast of closest places based on your location")
    }
    
    // CLLocation Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        var latitude = ""
        var longitude = ""
        
        if location.horizontalAccuracy > 0 {
            locationManager.startUpdatingLocation()
            print("long: \(location.coordinate.longitude), lat: \(location.coordinate.latitude)")
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            let params: [String: String] = ["lat": latitude, "lon": longitude, "cnt" : nearestCityamount ,"appid": weatherDataModel.apiId]
            
            getWeatherData(url: weatherDataModel.apiUrlOther, params: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: ", error)
    }
    
    func getWeatherData(url: String, params: [String: String]) {
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.value != nil {
                let weatherJSON: JSON = JSON(response.value!)
                print("weatherJSON: ", weatherJSON)
                
                let results = weatherJSON["list"].arrayValue
                
                for result in results {
                    let cityName = result["name"].stringValue
                    let temp = result["main"]["temp"].intValue - 273
                    let iconTemp = result["cod"].intValue
                    let icon = self.weatherDataModel.updateWeatherIcon(condition: iconTemp)
                    
                    self.cityName.append(cityName)
                    self.temp.append(temp)
                    self.icon.append(icon)
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print(self.cityName)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OtherCitiesTableViewCell
        
        cell.cityNameLabel.text = "\(cityName[indexPath.row])"
        cell.tempLabel.text = "\(temp[indexPath.row]) °C"
        cell.iconLabel.image = UIImage(systemName: icon[indexPath.row])
        
        return cell
    }
}
