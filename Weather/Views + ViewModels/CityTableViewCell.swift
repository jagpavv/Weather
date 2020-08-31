
import UIKit

class CityTableViewCell: UITableViewCell {
  static let identifier = String(describing: CityTableViewCell.self)

  @IBOutlet weak var cityLabel: UILabel!

  func fillCell(data: City) {
    self.cityLabel.text = data.name + ", " + data.country
  }
}
