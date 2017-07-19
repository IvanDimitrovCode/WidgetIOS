//
//  WeatherApi.swift
//  WidgetApp
//
//  Created by VCS on 7/18/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherApiDelegate {
    func onDataRecive(_ weatherData:(WeatherData))
    func onImageDownloaded(_ imageData:Data)
}

class WeatherApi {
    private static let API_DOMAIN       = "http://api.openweathermap.org/data/2.5/weather?q="
    private static let API_KEY          = "&APPID=8f992c317929ab6e9923c20ca01a5fd0"
    private static let REQUEST_TYPE     = "GET"
    private static let API_ICON_URL     = "http://openweathermap.org/img/w/"
    private static let API_ICON_SUFIX   = ".png"
    
    public static var delegate:WeatherApiDelegate?;
    
    public static func requestWeatherData(_ city:(String)) {
        let myUrl = NSURL(string: API_DOMAIN.appending(city).appending(API_KEY));
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = REQUEST_TYPE
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil || data == nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            delegate?.onDataRecive(WeatherDataParser.parseJsonToObjectData(data!))
        }
        task.resume()
    }
    
    public static func requestWeatherIcon(_ weatherData:WeatherData) {
        downloadImage(weatherData.icon!)
    }
    
    private static func downloadImage(_ imageName:String) {
        let imageUrlString = API_ICON_URL.appending(imageName).appending(API_ICON_SUFIX)
        let imageUrl:URL = URL(string: imageUrlString)!
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            delegate?.onImageDownloaded(imageData as Data)
        }
    }
}
