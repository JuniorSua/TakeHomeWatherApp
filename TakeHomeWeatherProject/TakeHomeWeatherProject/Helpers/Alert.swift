//
//  Alert.swift
//  TakeHomeWeatherProject
//
//  Created by Junior Suarez-Leyva on 8/23/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showErrorAlert(on vc: UIViewController, title: String) {
        DispatchQueue.main.async {
            showBasicAlert(on: vc, with: title, message: "An error has occurred, please try again (Make sure your network connection is on via your Settings > Wi-FI or Cellular). If the app reports the same error, please report the error at contact@takehomeweatherproject.com")
        }
    }
    
    static func showZipCodeErrorAlert(on vc: UIViewController, title: String) {
        DispatchQueue.main.async {
            showBasicAlert(on: vc, with: title, message: "Please make sure your Zip code is valid")
        }
    }
}
