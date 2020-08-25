//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Eunjin on 8/25/20.
//  Copyright © 2020 Two Berliners. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  static let identifier = String(describing: WeatherTableViewCell.self)

  @IBOutlet weak var cityLabel: UILabel!

  func fillCell(data: WeatherInfo) {
      self.cityLabel.text = "cell"
    }
}
