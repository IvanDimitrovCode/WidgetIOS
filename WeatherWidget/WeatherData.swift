//
//  WeatherData.swift
//  WidgetApp
//
//  Created by VCS on 7/18/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

import Foundation

class WeatherData {
    
    var name: String?;
    var lon = 0.0;
    var lat = 0.0;
    var temp = 0.0;
    var humidity = 0.0;
    var windSPD = 0.0;
    var pressure = 0.0;
    var icon: String?;
    var imageData: Data?;
}
