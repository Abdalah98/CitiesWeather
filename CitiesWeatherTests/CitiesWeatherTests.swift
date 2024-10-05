//
//  CitiesWeatherTests.swift
//  CitiesWeatherTests
//
//  Created by Abdallah Omar on 05/10/2024.
//

import XCTest
@testable import CitiesWeather

final class CitiesWeatherTests: XCTestCase {
    
    func testFetchCities() {
        let citiesVM = CitiesViewModel()
        let expectation = XCTestExpectation(description: "Fetch cities")
        
        citiesVM.fetchCities()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(citiesVM.cities.isEmpty, "Cities should not be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchWeather() {
        let weatherVM = WeatherViewModel()
        let city = City(id: 1, name: "Cairo", lat: 30.0444, lon: 31.2357)
        let expectation = XCTestExpectation(description: "Fetch weather data")
        
        weatherVM.fetchWeather(for: city)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(weatherVM.weatherData.isEmpty, "Weather data should not be empty")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
