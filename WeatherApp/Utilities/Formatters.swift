//
//  Formatters.swift
//  WeatherApp
//
//  Created by dorra on 1/20/21.
//

import Foundation

let timeFormatter: DateFormatter = {
  let formatter = DateFormatter()
    formatter.timeStyle = .short
  return formatter
}()

let dayFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd"
  return formatter
}()

let monthFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMMM"
  return formatter
}()


