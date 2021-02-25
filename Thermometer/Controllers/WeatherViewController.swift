//
//  WeatherViewController.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 21/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
   
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    let userDefaults = UserDefaults.standard
    let weatherDataModel = WeatherDataModel()
    let locationManager = CLLocationManager()
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // removeTabBarBorder()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let cityName = searchTextField.text else {
            return
        }
        
        userEnterCityName(city: cityName)
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        warningPopUP(withTitle: "Thermometer", withMessage: "Use your location coordinates to see weather conditions")
    }
    
    
    func removeTabBarBorder() {
        self.tabBarController!.tabBar.layer.borderWidth = 0.50
        self.tabBarController!.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBarController?.tabBar.clipsToBounds = true
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 150

            let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//            let titleImageView = weatherIcon
//            titleImageView?.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
//            titleView.addSubview(titleImageView!)
            navigationItem.titleView = titleView
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0  {
            self.view.frame.origin.y += 150

            navigationItem.titleView?.isHidden = true
        }
    }
    
    // CLLocation Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.startUpdatingLocation()
            print("long: \(location.coordinate.longitude), lat: \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": weatherDataModel.apiId]
            
            getWeatherData(url: weatherDataModel.apiUrl, params: params)
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
                
                self.updateWeatherData(json: weatherJSON)
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temp = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            weatherDataModel.pressure = json["main"]["pressure"].intValue
            weatherDataModel.wind = json["wind"]["speed"].doubleValue
            weatherDataModel.longitude = json["coord"]["lon"].doubleValue
            weatherDataModel.latitude = json["coord"]["lat"].doubleValue
            
            updateUI()
        } else {
            self.cityLabel.text = "Weather unavailable"
        }
    }

    // UpdateUI
    func updateUI() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temp)°C"
        weatherIcon.image = UIImage(systemName: weatherDataModel.weatherIconName)
        humidityLabel.text = "Humidity: \(weatherDataModel.humidity) %"
        pressureLabel.text = "Pressure: \(weatherDataModel.pressure) hPa"
        windLabel.text = "Wind: \(weatherDataModel.wind) km/h"
        longitudeLabel.text = "Longitude: \(weatherDataModel.longitude)"
        latitudeLabel.text = "Latitude: \(weatherDataModel.latitude)"

    }
    
    func userEnterCityName(city: String) {
        print(city)
        let params: [String:String] = ["q": city , "appid": weatherDataModel.apiId]
                
        getWeatherData(url: weatherDataModel.apiUrl, params: params)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}


