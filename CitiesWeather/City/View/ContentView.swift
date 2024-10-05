//
//  ContentView.swift
//  CitiesWeather
//
//  Created by Abdallah Omar on 05/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var citiesVM = CitiesViewModel()
    @StateObject private var weatherVM = WeatherViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // City selection dropdown
                Picker("Select a City", selection: $citiesVM.selectedCity) {
                    ForEach(citiesVM.cities) { city in
                        Text(city.name).tag(city as City?)
                    }
                }
                .onChange(of: citiesVM.selectedCity) { city in
                    if let city = city {
                        weatherVM.fetchWeather(for: city)
                    }
                }
                .padding()

                // Display weather or error message
                if let errorMessage = weatherVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(weatherVM.weatherData) { day in
                        HStack {
                            // Weather icon
                            Image(systemName: weatherVM.weatherIcon(for: day.weather.first?.description ?? ""))
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 10)

                            // Date and description
                            VStack(alignment: .leading) {
                                Text(day.dt_txt)
                                    .font(.headline)
                                Text(day.weather.first?.description.capitalized ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()

                            // Temperature in Celsius
                            Text("\(day.main.temp - 273.15, specifier: "%.1f") °C")
                                .font(.headline)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .navigationTitle("Daily Forecast")
            .onAppear {
                citiesVM.fetchCities()

                // Ensure there is a default selected city once cities are loaded
                if let firstCity = citiesVM.cities.first {
                    citiesVM.selectedCity = firstCity
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
