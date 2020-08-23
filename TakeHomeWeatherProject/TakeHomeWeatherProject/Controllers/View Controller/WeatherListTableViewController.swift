//
//  WeatherListTableViewController.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/21/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import UIKit

class WeatherListTableViewController: UITableViewController {
    
    //MARK: - Outlets
    var weatherResponse: [WeatherResponse]      = []
    var icon: String                            = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromPersistentStore()
        
        if weatherResponse.count == 0 {
            fetchNewYorkWeather()
            fetchSaltLakeCityWeather()
            fetchSanFranciscoWeather()
            
        }
        
        
        
        
        
    }
    
    //MARK: - Actions
    @IBAction func addNewCityTapped(_ sender: Any) {
        presentNewPostAlert(title: "Add a new city", message: "Please insert a United State Zip code only, should equal 5 digits")
    }
    
    
    
    
    //MARK: - Helper Methods
    
    
    
    
    
    func createFileForPersistentStore() -> URL {
        // Made a property = the path needed to take
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Weather.json")
        return fileURL
    }
    
    func saveToPersistentStore() {
        // Made a property that conforms to the JSONEncoder property
        let jsonEncoder = JSONEncoder()
        do {
            // Made a property to be the encoded version of myNotes
            let data = try jsonEncoder.encode(weatherResponse)
            // appending that note the file path created
            try data.write(to: createFileForPersistentStore())
            // since try can fail, made an error to be catch
        } catch let encodingError {
            print("There was an error saving to persistent storage: \(encodingError.localizedDescription) ")
            
        }
    }
    // Created a function to load the information added to the file path
    func loadFromPersistentStore() {
        // made a property be of type JSONDecoder
        let jsonDecoder = JSONDecoder()
        do {
            let decodeData = try Data(contentsOf: createFileForPersistentStore())
            self.weatherResponse = try jsonDecoder.decode([WeatherResponse].self, from: decodeData)
            // Catch the error from trying to decode
            print("Successfully loaded form persistence")
        } catch let decodingError {
            print("There was an error decoding the data \(decodingError.localizedDescription)")
        }
    }
    
    
    func delete(weatherResponse: WeatherResponse) {
        //created a property that equals the note that was passed in index
        guard let index = self.weatherResponse.firstIndex(of: weatherResponse) else { return }
        //deleted that note index from the SOT
        self.weatherResponse.remove(at: index)
        saveToPersistentStore()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func presentNewPostAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = " Example: (48917)"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let postAction = UIAlertAction(title: "Search", style: .default) { (_) in
            guard let bodyText = alertController.textFields?[0].text,
                !bodyText.isEmpty else { return }
            
            WeatherController.fetchWeatherWith(zipCode: bodyText) { (result) in
                
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let weather):
                        
                        for item in weather.weather {
                            self.icon = item.icon
                            print(item.icon)
                        }
                        
                        WeatherController.fetchIconWith(urlString: self.icon) { (result) in
                            
                            
                            switch result {
                                
                            case .success(_):
                                print("Successfully retrieved icon")
                                
                                print("This is how many are in the array2 \(self.weatherResponse.count)")
                            case .failure(let error):
                                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                            }
                        }
                        self.weatherResponse.append(weather)
                        self.saveToPersistentStore()
                        self.tableView.reloadData()
                        
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        
        self.present(alertController, animated: true)
        
    }
    
    func fetchSaltLakeCityWeather() {
        
        
        WeatherController.fetchWeatherWith(zipCode: "84103") { (result) in
            
            switch result {
                
            case .success(let weather):
                DispatchQueue.main.async {
                    for item in weather.weather {
                        self.icon = item.icon
                        print(item.icon)
                    }
                    
                    WeatherController.fetchIconWith(urlString: self.icon) { (result) in
                        switch result {
                            
                        case .success(_):
                            print("Successfully retrieved icon")
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                    self.weatherResponse.append(weather)
                    print("This is how many are in the array 1: \(self.weatherResponse.count)")
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
    }
    
    func fetchNewYorkWeather() {
        
        
        WeatherController.fetchWeatherWith(zipCode: "10001") { (result) in
            
            switch result {
                
            case .success(let weather):
                DispatchQueue.main.async {
                    for item in weather.weather {
                        self.icon = item.icon
                        print(item.icon)
                    }
                    
                    WeatherController.fetchIconWith(urlString: self.icon) { (result) in
                        switch result {
                            
                        case .success(_):
                            print("Successfully retrieved icon")
                            
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                    self.weatherResponse.append(weather)
                    print("This is how many are in the array 2: \(self.weatherResponse.count)")
                    
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
    }
    
    func fetchSanFranciscoWeather() {
        
        
        WeatherController.fetchWeatherWith(zipCode: "94104") { (result) in
            
            switch result {
                
            case .success(let weather):
                DispatchQueue.main.async {
                    for item in weather.weather {
                        self.icon = item.icon
                        print(item.icon)
                    }
                    
                    WeatherController.fetchIconWith(urlString: self.icon) { (result) in
                        switch result {
                            
                        case .success(_):
                            print("Successfully retrieved icon")
                            
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                    self.weatherResponse.append(weather)
                    print("This is how many are in the array 3: \(self.weatherResponse.count)")
                    
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return weatherResponse.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        let weatherResponse         = self.weatherResponse[indexPath.row]
        cell.weatherResponse        = weatherResponse
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = weatherResponse[indexPath.row]
            delete(weatherResponse: city)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Successfully deleted")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? WeatherDetailViewController else { return }
            let weather = weatherResponse[indexPath.row]
            destinationVC.weatherResponse = weather
            
        }
        
    }
    
    
}
