
import UIKit

class CityListTableViewCell: UITableViewCell {
  static let identifier = String(describing: CityListTableViewCell.self)

  @IBOutlet weak var cityLabel: UILabel!

  func fillCell(data: City) {
    self.cityLabel.text = data.name + ", " + data.country
  }
}
