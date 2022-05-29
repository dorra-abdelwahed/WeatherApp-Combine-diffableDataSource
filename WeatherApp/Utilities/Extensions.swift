//
//  Extensions.swift
//  WeatherApp
//
//  Created by dorra on 1/28/21.
//

import Foundation


public extension Array where Element: Hashable {
  static func removeDuplicates(_ elements: [Element]) -> [Element] {
    var seen = Set<Element>()
    return elements.filter{ seen.insert($0).inserted }
  }
}
