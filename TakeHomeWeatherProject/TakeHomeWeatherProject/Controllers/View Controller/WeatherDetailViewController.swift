//
//  WeatherDetailViewController.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/22/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet var cityNameLabel:            UILabel!
    @IBOutlet var temperatureLabel:         UILabel!
    @IBOutlet var lowTemperatureLabel:      UILabel!
    @IBOutlet var highTemperatureLabel:     UILabel!
    @IBOutlet var humidityLabel:            UILabel!
    
    @IBOutlet var weatherIconImageView:     UIImageView!
    @IBOutlet var weatherDescriptionLabel:  UILabel!
    
    var weatherResponse: WeatherResponse? {
        didSet {
            updateViewsWithWeatherItem()
        }
    }
    
    func updateViewsWithWeatherItem() {
        
        guard let weatherResponse = weatherResponse else { return }
        
        for item in weatherResponse.weather {
            let urlString       = item.icon
            let description     = item.description
            WeatherController.fetchIconWith(urlString: urlString) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        self.weatherIconImageView.image     = image
                        self.weatherDescriptionLabel.text   = description
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                    
                    guard let weatherResponse       = self.weatherResponse else { return }
                    self.cityNameLabel.text         = weatherResponse.name
                    self.temperatureLabel.text      = "\(weatherResponse.main.temperature)ºF"
                    self.lowTemperatureLabel.text   = "\(weatherResponse.main.lowTemperature)ºF"
                    self.highTemperatureLabel.text  = "\(weatherResponse.main.highTemperature)ºF"
                    self.humidityLabel.text         = "\(weatherResponse.main.humidity)%"
                }
            }
        }
    }
}
