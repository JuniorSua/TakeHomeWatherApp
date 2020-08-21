//
//  WeatherError.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/20/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        
        switch self {
        case .invalidURL:
            return "We have an invalid url"
        case .thrownError(let error):
            return error.localizedDescription
        case .noData:
            return "We have no data"
        case .unableToDecode:
            return "We were not able to decode"
        }
    }
}
