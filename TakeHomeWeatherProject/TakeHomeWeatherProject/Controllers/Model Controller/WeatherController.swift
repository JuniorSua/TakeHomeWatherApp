//
//  WeatherController.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/20/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import Foundation
import UIKit.UIImage

class WeatherController {
    
    static let shared                           = WeatherController()
    var weatherResponse: [WeatherResponse]      = []
    
    static let iconBaseURL                      = URL(string: "http://openweathermap.org/img/w/")
    static let png                              = ".png"
    
    static let baseURL                          = URL(string: "http://api.openweathermap.org/data/2.5")
    static let weatherComponent                 = "weather"
    static let zipQuery                         = "zip"
    static let unitQuery                        = "units"
    static let unitImperialValue                = "imperial"
    static let apiID                            = "appid"
    static let apiValue                         = "da65fafb6cb9242168b7724fb5ab75e7"
    static let countryCode                      = ",us"
    
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
                
                //MARK: - Delete Print Statements
                print(weatherResponse.main.temperature)
                print(weatherResponse.name)
                
                for item in weatherResponse.weather {
                    print(item.icon)
                }
            
                completion(.success(weatherResponse))
                
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
    }
    
    static func fetchIconWith(urlString: String, completion: @escaping (Result<UIImage, WeatherError>) -> Void) {
        
        guard let baseURL       = iconBaseURL else { return completion(.failure(.invalidURL)) }
        let finalURL            = baseURL.appendingPathComponent(urlString + png)
        print(finalURL)
        print(urlString)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let icon = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            return completion(.success(icon))
            
        }.resume()
        
    }
    
    
    func createFileForPersistentStore() -> URL {
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Weather.json")
        return fileURL
        
    }
    
    func saveToPersistentStore() {
        
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(weatherResponse)
            try data.write(to: createFileForPersistentStore())
        } catch let encodingError {
            print("There was an error saving to persistent storage: \(encodingError.localizedDescription) ")
            
        }
    }
    
    func loadFromPersistentStore() {
        
        let jsonDecoder = JSONDecoder()
        do {
            let decodeData = try Data(contentsOf: createFileForPersistentStore())
            self.weatherResponse = try jsonDecoder.decode([WeatherResponse].self, from: decodeData)
            print("Successfully loaded form persistence")
        } catch let decodingError {
            print("There was an error decoding the data \(decodingError.localizedDescription)")
            
        }
    }
    
    func delete(weatherResponse: WeatherResponse) {
        
        guard let index = self.weatherResponse.firstIndex(of: weatherResponse) else { return }
        self.weatherResponse.remove(at: index)
        saveToPersistentStore()
        
    }
    
}// End of class
