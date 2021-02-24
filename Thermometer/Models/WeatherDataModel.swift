//
//  WeatherDataModel.swift
//  Thermometer
//
//  Created by Edgars Jaudzems on 22/02/2021.
//

import Foundation

class WeatherDataModel{
    
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather"
    let apiId = "a068820374d42ea9e308a8c8de8546a8"
    
    let apiUrlOther = "https://api.openweathermap.org/data/2.5/find?"

    var temp: Int = 0
    var condition: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var humidity: Int = 0
    var pressure: Int = 0
    var wind: Double = 0.0
    var longitude: Double = 0.0
    var latitude: Double = 0.0

    func updateWeatherIcon(condition: Int) -> String {
        switch (condition) {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

