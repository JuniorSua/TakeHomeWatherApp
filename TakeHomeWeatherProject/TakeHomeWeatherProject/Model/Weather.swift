//
//  Weather.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/20/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    
    let weather: [Weather]
    let main: Main
    let name: String
    
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
}

struct Main: Codable {
    private enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case lowTemperature = "temp_min"
        case highTemperature = "temp_max"
        case humidity = "humidity"
        
    }
    
    let temperature: Double
    let lowTemperature: Double
    let highTemperature: Double
    let humidity: Double
    
}

extension WeatherResponse: Equatable {
    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        return lhs.name == rhs.name
    }
}




