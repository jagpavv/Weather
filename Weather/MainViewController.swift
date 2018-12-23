import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let cellIdentifier = "weatherDisplayCell"
  var tempCityArr: [String] = [String]()
  let tempTemperaure: [String] = ["1"]
  let tempImageName = "01d"

  @IBOutlet weak var tableView: UITableView!

  @IBAction func unwindFromSearchCityView(_ segue: UIStoryboardSegue) {


    //    if sender.source is AddCharacterViewController {
    //      if let senderVC = sender.source as? AddCharacterViewController {
    //        //SAVE TO CORE DATA
    //        save(name: senderVC.character)
    //        //                madMenCharacters.append(senderVC.character)
    //      }
    //      tableView.reloadData()
    //    }

    tableView.reloadData()
    print("MinViewController's tempCityArr \(tempCityArr)")
    print("successfully unwined form search city view Controller")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tempCityArr.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel.text = self.tempCityArr[indexPath.row]
    cell.temperatureLabel.text = self.tempTemperaure[indexPath.row]
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }
}
