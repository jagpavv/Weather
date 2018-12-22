import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let cellIdentifier = "weatherDisplayCell"
  let tempCityName: [String] = ["A", "B", "C", "D", "A", "B", "C" ]
  let tempTemperaure: [String] = ["1", "2", "3", "4", "5", "6", "7"]
  let tempImageName = "01d"


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tempCityName.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel.text = self.tempCityName[indexPath.row]
    cell.temperatureLabel.text = self.tempTemperaure[indexPath.row]
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
