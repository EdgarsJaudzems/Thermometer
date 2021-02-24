//
//  OtherCitiesTableViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 23/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class OtherCitiesTableViewController: UITableViewController {

    let weatherDataModel = WeatherDataModel()
    let cityURL = "https://api.openweathermap.org/data/2.5/find?lat=37.7&lon=-122.4&cnt=40&units=metric&appid=a068820374d42ea9e308a8c8de8546a8"
    var cityName = [String]()
    var temp = [String]()
    var icon = [Int]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData(url: cityURL)
    }
    
    func getWeatherData(url: String) {
        AF.request(url, method: .get).responseJSON { (response) in
            if response.value != nil {
                let weatherJSON: JSON = JSON(response.value!)
                print("weatherJSON: ", weatherJSON)
                
                let results = weatherJSON["list"].arrayValue
                
                for result in results {
                    let cityName = result["name"].stringValue
                    let temp = result["main"]["temp"].stringValue
                    let icon = result["cod"].intValue

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
        return 100
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityName.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OtherCitiesTableViewCell

        cell.cityNameLabel.text = "\(cityName[indexPath.row])"
        cell.tempLabel.text = "\(temp[indexPath.row]) °C"

      //  cell.iconLabel.image = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)

        cell.iconLabel.image = UIImage(systemName: "sun.max")
        
        return cell
    }
}
