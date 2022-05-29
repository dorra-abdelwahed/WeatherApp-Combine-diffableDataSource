//
//  WeeklyCustomTableViewCell.swift
//  WeatherApp
//
//  Created by dorra on 1/19/21.
//

import UIKit

class WeeklyCustomTableViewCell: UITableViewCell {

    static let identifier = "WeeklyCustomTableViewCell"
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherSecondLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func setup(with state:  WeeklyWeather) {
        let weather = state.title
        switch  weather{
        case "Rain":
            weatherLabel.text = "🌧️"
        case "Clouds":
            weatherLabel.text = "☁️"
        case "Snow":
            weatherLabel.text = "🌨️"
        default:
            weatherLabel.text = "☀️"
        }
        
        weatherSecondLabel.text = state.fullDescription
        dayLabel.text = state.day
        monthLabel.text = state.month
        tempLabel.text = state.temperature
    }
}
