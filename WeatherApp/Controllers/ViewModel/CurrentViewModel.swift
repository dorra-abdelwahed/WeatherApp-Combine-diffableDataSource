//
//  CurrentViewModel.swift
//  WeatherApp
//
//  Created by dorra on 1/28/21.
//

import Foundation


struct CurrentWeather {
  private let item: CurrentWeatherForecastResponse
  
    var id: String {
      return time + temperature + title
    }
    
  var temperature: String {
    return String(format: "%.1f", item.main.temperature)
  }
  
  var maxTemperature: String {
    return String(format: "%.1f", item.main.maxTemperature)
  }
  
  var minTemperature: String {
    return String(format: "%.1f", item.main.minTemperature)
  }
  
    var title: String {
      guard let title = item.weather.first?.main.rawValue else { return "" }
      return title
    }
    
    var fullDescription: String {
      guard let description = item.weather.first?.weatherDescription else { return "" }
      return description
    }
    
    var time: String {
        return timeFormatter.string(from: item.date)
    }
  
  init(item: CurrentWeatherForecastResponse) {
    self.item = item
  }
}

extension CurrentWeather: Hashable {
  static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
    return lhs.time == rhs.time
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.time)
  }
}

