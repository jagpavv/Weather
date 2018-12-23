import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let cellIdentifier = "weatherDisplayCell"
  var tempCityArr: [String] = [String]()
  let tempTemperaure: [String] = [String]()
  let tempImageName = "01d"

  @IBAction func unwindFromSearchCityView(_ segue: UIStoryboardSegue) {
    print("MinViewController's tempCityArr \(tempCityArr)")

//    if sender.source is AddCharacterViewController {
//      if let senderVC = sender.source as? AddCharacterViewController {
//        //SAVE TO CORE DATA
//        save(name: senderVC.character)
//        //                madMenCharacters.append(senderVC.character)
//      }
//      tableView.reloadData()
//    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
