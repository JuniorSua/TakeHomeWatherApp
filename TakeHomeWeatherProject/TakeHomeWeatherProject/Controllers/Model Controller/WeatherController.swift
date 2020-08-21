//
//  WeatherController.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/20/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import Foundation

class WeatherController {
    
    static let shared               = WeatherController()
    
    static let baseURL              = URL(string: "http://api.openweathermap.org/data/2.5")
    static let weatherComponent     = "weather"
    static let zipQuery             = "zip"
    static let unitQuery            = "units"
    static let unitImperialValue    = "imperial"
    static let apiID                = "appid"
    static let apiValue             = "da65fafb6cb9242168b7724fb5ab75e7"
    static let countryCode          = ",us"
    
    static func fetchWeatherWith(zipCode: String, completion: @escaping (Result<WeatherResponse,WeatherError>) -> Void) {
        
        guard let baseURL           = baseURL else { return completion(.failure(.invalidURL)) }
        let url                     = baseURL.appendingPathComponent(weatherComponent)
        
        var components              = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let zipQueryItem            = URLQueryItem(name: zipQuery, value: zipCode + countryCode)
        let unitQueryItem           = URLQueryItem(name: unitQuery, value: unitImperialValue)
        let apiIDQueryItem          = URLQueryItem(name: apiID, value: apiValue)
        components?.queryItems      = [zipQueryItem, unitQueryItem, apiIDQueryItem]
        
        guard let finalURL          = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                print(weatherResponse.main.temperature)
                completion(.success(weatherResponse))
                
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}// End of class
