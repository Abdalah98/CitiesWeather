//
//  WeatherViewModel.swift
//  CitiesWeather
//
//  Created by Abdallah Omar on 05/10/2024.
//

import Combine
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weatherData: [WeatherDay] = []
    @Published var errorMessage: String? = nil
    private let apiKey = "c24867c2c34070e7d74a8712710d6583"

    func fetchWeather(for city: City) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let jsonString = String(data: data, encoding: .utf8)
                print("Weather API Response: \(jsonString ?? "Invalid JSON")")
                
                let decoder = JSONDecoder()
                if let weatherResponse = try? decoder.decode(WeatherResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.weatherData = weatherResponse.list
                        self.cacheWeather(for: city, data: weatherResponse.list)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to load weather data."
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "No internet connection, fetching cached data..."
                    if let cachedData = self.fetchCachedWeather(for: city) {
                        self.weatherData = cachedData
                    } else {
                        self.errorMessage = "No cached data available."
                    }
                }
            }
        }.resume()
    }

    // Returns an SF Symbol icon based on the weather description
    func weatherIcon(for description: String) -> String {
        switch description.lowercased() {
        case "clear", "clear sky":
            return "sun.max.fill"
        case "rain", "shower rain":
            return "cloud.rain.fill"
        case "snow":
            return "cloud.snow.fill"
        case "extreme", "thunderstorm":
            return "cloud.bolt.fill"
        default:
            return "cloud.fill"
        }
    }

    // Caching the weather data locally in UserDefaults
    func cacheWeather(for city: City, data: [WeatherDay]) {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: "weather_\(city.name)")
        }
    }

    // Fetch cached weather data from UserDefaults
    func fetchCachedWeather(for city: City) -> [WeatherDay]? {
        let defaults = UserDefaults.standard
        if let savedWeather = defaults.object(forKey: "weather_\(city.name)") as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode([WeatherDay].self, from: savedWeather)
        }
        return nil
    }
}
