import UIKit

class MainViewCell: UITableViewCell {
  static let identifier = String(describing: MainViewCell.self)

  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var conditionImageView: UIImageView!

  func fillCell(data: WeatherInfo) {
    self.cityLabel.text = data.name
    self.temperatureLabel.text = String(data.main.temp.rounded())
    if let iconId = data.weather?[0].icon {
      self.conditionImageView.image = UIImage(named: iconId)
    }
  }
}
