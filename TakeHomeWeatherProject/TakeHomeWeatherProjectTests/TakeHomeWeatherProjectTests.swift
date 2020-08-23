//
//  TakeHomeWeatherProjectTests.swift
//  TakeHomeWeatherProjectTests
//
//  Created by Junior Suarez-Leyva on 8/20/20.
//  Copyright © 2020 Junior Suarez-Leyva. All rights reserved.
//

import XCTest
@testable import TakeHomeWeatherProject

class TakeHomeWeatherProjectTests: XCTestCase {
    
    var weather: WeatherController!

    override func setUp() {
        super.setUp()
        weather = WeatherController()
    }
    
    override func tearDown() {
        weather = nil
        super.tearDown()
    }
    
    func testIsBaseURL() {
        let expectedURL = URL(string: "http://api.openweathermap.org/data/2.5")
        let baseURL = WeatherController.baseURL
        
        XCTAssertEqual(expectedURL, baseURL)
    }
    
    func testIsIconBaseURL() {
        let expectedURL = URL(string: "http://openweathermap.org/img/w/")
        let iconBaseURL = WeatherController.iconBaseURL
        
        XCTAssertEqual(expectedURL, iconBaseURL)
    }
    
    func testIsImagePng() {
        let expectedImageType = ".png"
        let png = WeatherController.png
        
        XCTAssertEqual(expectedImageType, png)
    }
    
    func testIsWeatherComponent() {
        let expectedWeatherComponent = "weather"
        let weatherComponent = WeatherController.weatherComponent
        
        XCTAssertEqual(expectedWeatherComponent, weatherComponent)
    }
    
    func testIsQueryZip() {
        let expectedZipQuery = "zip"
        let zipQuery = WeatherController.zipQuery
        
        XCTAssertEqual(expectedZipQuery, zipQuery)
    }
    
    func testIsQueryUnit() {
        let expectedUnitQuery = "units"
        let unitQuery = WeatherController.unitQuery
        
        XCTAssertEqual(expectedUnitQuery, unitQuery)
    }
    
    func testIsUnitImperial() {
        let expectedUnit = "imperial"
        let unit = WeatherController.unitImperialValue
        
        XCTAssertEqual(expectedUnit, unit)
    }
    
    func testIsAPIIDQuery() {
        let expectedAPIIDQuery = "appid"
        let apiIDQuery = WeatherController.apiID
        
        XCTAssertEqual(expectedAPIIDQuery, apiIDQuery)
    }
    
    func testIsAPIValue() {
        let expectedAPIValue = "da65fafb6cb9242168b7724fb5ab75e7"
        let apiValue = WeatherController.apiValue
        
        XCTAssertEqual(expectedAPIValue, apiValue)
    }
    
    func testIsCountryCode() {
        let expectedCountryCode = ",us"
        let countryCode = WeatherController.countryCode
        
        XCTAssertEqual(expectedCountryCode, countryCode)
    }
}
