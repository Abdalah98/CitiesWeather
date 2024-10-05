//
//  CitiesViewModel.swift
//  CitiesWeather
//
//  Created by Abdallah Omar on 05/10/2024.
//

import SwiftUI

class CitiesViewModel: ObservableObject {
    @Published var cities: [City] = []
    @Published var selectedCity: City?

    func fetchCities() {
        let urlString = "https://dev-orcas.s3.eu-west-1.amazonaws.com/uploads/cities.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let citiesResponse = try? decoder.decode(CitiesResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.cities = citiesResponse.cities
                        // Set default selection
                        self.selectedCity = self.cities.first
                    }
                } else {
                    print("Failed to decode JSON")
                }
            }
        }.resume()
    }
}
