import UIKit
import Foundation
import Alamofire
import CoreLocation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?q="
  private let openWeatherMapAPIKey = "&APPID=4c8b3b461a4559a8ac0c397de4b3aaaf"

  let cellIdentifier = "weatherDisplayCell"

  var weatherInfos = [WeatherInfo]()
  var weatherDic = [String: Any]()
  var weather = [[String: Any]]()
  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  var tempSelectedCityArr: [String] = [String]()
  var selectedCity: [String] = []

  // Properties below this line undecide yet let or var
//  var tempTemperaure: [Double] = [Double]()
  let tempImageName = "01d"

  @IBOutlet weak var tableView: UITableView!

  @IBAction func unwindFromSearchCityView(_ segue: UIStoryboardSegue) {
    tableView.reloadData()
    getWeather()
    print("MinViewController's selectedCity \(selectedCity)")
    print("successfully unwined form search city view Controller")
  }

//  override func viewDidLoad() {
//    super.viewDidLoad()
//    getWeather()
//  }

//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    getWeather()
//  }

  func getWeather() {
    
    for i in 0..<selectedCity.count {
      let cityString = selectedCity[i]
      print("cityString \(cityString)")

      let url = openWeatherMapBaseURL + cityString + openWeatherMapAPIKey
      print(url)

      Alamofire.request(url, method: .get).validate().responseData { response in
        switch response.result {
        case.success(let data):
          guard let weatherInfo = try? self.jsonDecoder.decode(WeatherInfo.self, from: data) else { return }
          self.weatherInfos.append(weatherInfo)
          print(self.weatherInfos)
        case .failure(let error):
          print(error)
        }
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedCity.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel.text = self.selectedCity[indexPath.row]
//    cell.temperatureLabel.text = String(self.tempTemperaure[indexPath.row])
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }
}
