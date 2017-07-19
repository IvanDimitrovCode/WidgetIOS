//
//  WeatherDataParser.swift
//  WidgetApp
//
//  Created by VCS on 7/19/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

import Foundation
class WeatherDataParser {
    
    public static func parseJsonToObjectData(_ data: Data) -> WeatherData {
        let weather_data = WeatherData()
        
        do {
            if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                print()
                weather_data.name = convertedJsonIntoDict["name"] as? String
                
                let coordinates = convertedJsonIntoDict["coord"] as! [String:Any]
                weather_data.lat = coordinates["lat"] as! Double
                weather_data.lon = coordinates["lon"] as! Double
                
                let mainData = convertedJsonIntoDict["main"] as! [String: Any]
                weather_data.temp = mainData["temp"] as! Double - 273
                weather_data.humidity = mainData["humidity"] as! Double
                weather_data.pressure = mainData["pressure"] as! Double
                
                let weather = convertedJsonIntoDict["weather"] as? [[String: Any]]
                for item in weather! {
                    weather_data.icon = item["icon"] as? String
                    break
                }
                
                let windData = convertedJsonIntoDict["wind"] as! [String: Any]
                weather_data.windSPD = windData["speed"] as! Double
                
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return weather_data
    }
}
