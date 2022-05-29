//
//  WeatherError.swift
//  WeatherApp
//
//  Created by dorra on 1/22/21.
//

import Foundation

enum WeatherError: Error{
    case parsing(description: String)
    case network(description: String)
}
