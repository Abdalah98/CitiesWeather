//
//  City.swift
//  CitiesWeather
//
//  Created by Abdallah Omar on 05/10/2024.
//

import Foundation

struct CitiesResponse: Codable {
    let cities: [City]
}

struct City: Identifiable, Codable, Hashable, Equatable {
    let id: Int
    let name: String
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name = "cityNameEn"
        case lat
        case lon
    }
}


struct WeatherResponse: Codable {
    let list: [WeatherDay]
}

struct WeatherDay: Identifiable, Codable {
    let id = UUID()
    let dt_txt: String
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let description: String
}

struct Main: Codable {
    let temp: Double
}

