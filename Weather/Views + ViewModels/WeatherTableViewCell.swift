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
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var weatherImageView: UIImageView!

  func fillCell(data: WeatherInfo) {
    self.cityLabel.text = data.name
    self.temperatureLabel.text = String(data.main?.temp?.rounded())
    if let iconId = data.weather?[0].icon {
      self.weatherImageView.image = UIImage(named: iconId)
    }
  }
}

extension String {
  init?<T: LosslessStringConvertible>(_ value : T?) {
    guard let value = value else { return nil }
    self.init(value)
  }
}
