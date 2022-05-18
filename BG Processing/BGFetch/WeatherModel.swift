//
//  WeatherModel.swift
//  BG Processing
//
//  Created by Pratik on 19/05/22.
//

import Foundation

class WeatherModel : NSObject
{
    var currentWeather   : CurrentWeather?
    var weatherForecasts : [WeatherForecast] = []
    
    init(_ json: Any?)
    {
        guard let dic = json as? Dictionary else { return }

        if let dicCurrentWeather = dic["currentConditions"] as? Dictionary {
            self.currentWeather = CurrentWeather.init(dicCurrentWeather)
        }
        
        if let arrWeatherForecasts = dic["next_days"] as? [Dictionary] {
            self.weatherForecasts = arrWeatherForecasts.map({WeatherForecast.init($0)})
        }
    }
}

class CurrentWeather
{
    var time          : Date?
    var condition     : String = ""
    var chancesOfRain : Double = 0
    var humidity      : Double = 0
    var iconURL       : String = ""
    var tempCelcius   : Double = 0
    var windSpeedKM   : Double = 0

    init(_ json: Any?)
    {
        guard let dic = json as? Dictionary else { return }

        self.time = Date()
        self.condition = dic["comment"] as? String ?? ""
        self.chancesOfRain = dic["precip"] as? Double ?? 0
        self.humidity = dic["humidity"] as? Double ?? 0
        self.iconURL = dic["iconURL"] as? String ?? ""
        
        if let dicTemp = dic["temp"] as? Dictionary {
            self.tempCelcius = dicTemp["c"] as? Double ?? 0
        }

        if let dicWind = dic["wind"] as? Dictionary {
            self.windSpeedKM = dicWind["km"] as? Double ?? 0
        }
    }
}

class WeatherForecast
{
    var day            : String = ""
    var condition      : String = ""
    var iconURL        : String = ""
    var minTempCelcius : Double = 0
    var maxTempCelcius : Double = 0

    init(_ json: Any?)
    {
        guard let dic = json as? Dictionary else { return }

        self.day = dic["day"] as? String ?? ""
        self.condition = dic["comment"] as? String ?? ""
        self.iconURL = dic["iconURL"] as? String ?? ""
        
        if let dicTemp = dic["min_temp"] as? Dictionary {
            self.minTempCelcius = dicTemp["c"] as? Double ?? 0
        }

        if let dicWind = dic["max_temp"] as? Dictionary {
            self.maxTempCelcius = dicWind["km"] as? Double ?? 0
        }
    }
}
