//
//  WeatherTableViewCell.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/21/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIconImageView: UIImageView!
    
    
    var weatherResponse: WeatherResponse? {
        didSet {
            updateViewsWithWeatherItem()
        }
    }
    
    func updateViewsWithWeatherItem() {
        
        guard let weatherResponse = weatherResponse else { return }
        
        for item in weatherResponse.weather {
            let urlString = item.icon
            
                WeatherController.fetchIconWith(urlString: urlString) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            self.weatherIconImageView.image = image
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                        
                        guard let weatherResponse = self.weatherResponse else { return }
                        self.cityNameLabel.text = weatherResponse.name
                        self.temperatureLabel.text = "\(weatherResponse.main.temperature)ºF"
                        
                    }
                }
            
        }
        
        
    }
}
