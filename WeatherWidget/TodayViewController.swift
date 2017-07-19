//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by VCS on 7/18/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding,WeatherApiDelegate {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var windSPDLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var CityNameLabel: UILabel!
    
    var timer = Timer()
    var cityList : Array<String> = Array()
    var cityIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateCityList();
        
        WeatherApi.delegate = self
        updateWidget()
    }
    
    func populateCityList() {
        cityList = ["Georgi", "Veni", "London", "Moscow", "Sofia", "Paris"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func updateWidget() {
        if(cityIndex >= cityList.count) {
            cityIndex = 0
        }
        WeatherApi.requestWeatherData(cityList[cityIndex])
        cityIndex += 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateWidget), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer, forMode: .commonModes)
    }
    
    func onDataRecive(_ weatherData: (WeatherData)) {
        DispatchQueue.main.async {
            self.CityNameLabel.text = weatherData.name
            self.windSPDLabel.text = weatherData.windSPD.description
            self.pressureLabel.text = weatherData.pressure.description
            self.tempLabel.text = weatherData.temp.description
            self.humidityLabel.text = weatherData.humidity.description
            self.lonLabel.text = weatherData.lon.description
            self.latLabel.text = weatherData.lat.description
            WeatherApi.requestWeatherIcon(weatherData)
        }
    }
    
    func onImageDownloaded(_ imageData: Data) {
        DispatchQueue.main.async {
            let image = UIImage(data: imageData as Data)
            self.weatherImageView.image = image
        }
    }
}
