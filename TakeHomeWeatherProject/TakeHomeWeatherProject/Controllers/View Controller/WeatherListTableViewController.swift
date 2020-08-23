//
//  WeatherListTableViewController.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/21/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import UIKit

class WeatherListTableViewController: UITableViewController {
    
    var icon: String                            = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    //MARK: - Actions
    @IBAction func addNewCityTapped(_ sender: Any) {
        presentNewPostAlert(title: "Add a new city", message: "Please insert a United State Zip code only, should equal 5 digits")
    
    }
    
    //MARK: - Helper Method
    
    func loadData() {
        
        WeatherController.shared.loadFromPersistentStore()
        
        if WeatherController.shared.weatherResponse.count == 0 {
            fetchNewYorkWeather()
            fetchSaltLakeCityWeather()
            fetchSanFranciscoWeather()
            
        }
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
                                print("This is how many are in the array2 \(WeatherController.shared.weatherResponse.count)")
                            case .failure(let error):
                                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                                
                            }
                        }
                        WeatherController.shared.weatherResponse.append(weather)
                        WeatherController.shared.saveToPersistentStore()
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
                self.loadIconWith(weather: weather)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func fetchNewYorkWeather() {
        
        WeatherController.fetchWeatherWith(zipCode: "10001") { (result) in
            
            switch result {
            case .success(let weather):
                self.loadIconWith(weather: weather)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func fetchSanFranciscoWeather() {
        
        WeatherController.fetchWeatherWith(zipCode: "94104") { (result) in
            
            switch result {
            case .success(let weather):
                self.loadIconWith(weather: weather)
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
    
    func loadIconWith(weather: WeatherResponse) {
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
            WeatherController.shared.weatherResponse.append(weather)
            print("This is how many are in the array 3: \(WeatherController.shared.weatherResponse.count)")
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WeatherController.shared.weatherResponse.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        
        let weatherResponse         = WeatherController.shared.weatherResponse[indexPath.row]
        cell.weatherResponse        = weatherResponse
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = WeatherController.shared.weatherResponse[indexPath.row]
            WeatherController.shared.delete(weatherResponse: city)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Successfully deleted")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? WeatherDetailViewController else { return }
            let weather = WeatherController.shared.weatherResponse[indexPath.row]
            destinationVC.weatherResponse = weather
            
        }
    }
}
