import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?q="
  private let openWeatherMapAPIKey = "&APPID=4c8b3b461a4559a8ac0c397de4b3aaaf"

  let cellIdentifier = "weatherDisplayCell"

  // Properties below this line undecide yet let or var
//  var weatherInfos = [WeatherInfo]()

  var selectedCity: [String] = [String]()
  let tempTemperaure: [String] = ["1"]
  let tempImageName = "01d"

  @IBOutlet weak var tableView: UITableView!

  @IBAction func unwindFromSearchCityView(_ segue: UIStoryboardSegue) {
    tableView.reloadData()
    print("MinViewController's selectedCity \(selectedCity)")
    print("successfully unwined form search city view Controller")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let url = openWeatherMapBaseURL + "London" + openWeatherMapAPIKey

    print(url)

    Alamofire.request(url, method: .get).validate().responseJSON { response in
      switch response.result {
      case.success(let value):
        let json = JSON(value)

        let cityName = json["name"].stringValue
        let temperature = json["main"]["temp"].doubleValue
        let iconID = json["weather"][0]["icon"].stringValue

        print(cityName)
        print(temperature)
        print(iconID)

//        for infoDic in json.arrayValue {
//          let info = WeatherInfo.init(infos: infoDic)
//          self.weatherInfos.append(info)
//
//          print(self.weatherInfos)
//        }
      case .failure(let error):
        print(error)
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedCity.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel.text = self.selectedCity[indexPath.row]
    cell.temperatureLabel.text = self.tempTemperaure[indexPath.row]
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }
}
