import UIKit
import Foundation
import Alamofire
import CoreLocation
import CoreData

extension Date {
  var millisecondsSince1970:Int {
    return Int((self.timeIntervalSince1970 * 1000.0).rounded())
  }
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SearchCityDelegate {

  func searchCityList() -> [String]? {
    return cityList
  }

  func searchCitySelected(city: String) {
    guard !selectedCities.contains(city) else { return }
    selectedCities.append(city)
    tableView.reloadData()
    UserDefaults.standard.set(selectedCities, forKey: kSelectedCitiesKey)
    UserDefaults.standard.synchronize()
    print("searchCitySelected \(selectedCities)")
  }

  // MARK: - Properties
  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?q="
  private let openWeatherMapAPIKey = "&APPID=4c8b3b461a4559a8ac0c397de4b3aaaf"
  private let cellIdentifier = "weatherDisplayCell"
  private let kSelectedCitiesKey = "SelectedCities"
  private let kCityListKey = "cityList"

  @IBOutlet weak var addButton: UIButton!

  private var cityList = [String]()
  private var weatherInfos = [WeatherInfo]()
  var selectedCities = [String]()

  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private let tempImageName = "01d"

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let cities = UserDefaults.standard.stringArray(forKey: kSelectedCitiesKey) {
      selectedCities = cities
      print(selectedCities)
    }
    self.getCityList()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func getCityList() {
    let now = Date().millisecondsSince1970

    if let cities = UserDefaults.standard.stringArray(forKey: kCityListKey) {
      cityList = cities
      print("mili1: \(Date().millisecondsSince1970 - now)")
    } else if let asset = NSDataAsset(name: "cityList", bundle: Bundle.main) {
      do {
        if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
          for city in json {
            let name = city["name"] as! String
            cityList.append(name)
          }
          print("mili2: \(Date().millisecondsSince1970 - now)")
          UserDefaults.standard.set(cityList, forKey: kCityListKey)
          UserDefaults.standard.synchronize()
        }
      }
    }
    self.addButton.isEnabled = !cityList.isEmpty
    print("cityList.count: \(cityList.count)")
  }

  private func getWeather(from city: String) {
    let url = openWeatherMapBaseURL + city + openWeatherMapAPIKey
    print(url)

    Alamofire.request(url, method: .get).validate().responseData { response in
      switch response.result {
      case.success(let data):
        guard let weatherInfo = try? self.jsonDecoder.decode(WeatherInfo.self, from: data) else { return }
        self.weatherInfos.append(weatherInfo)
        self.tableView.reloadData()
        dump(self.weatherInfos)
      case .failure(let error):
        print(error)
      }
    }
  }

  // MARK: - Tableview Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedCities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel?.text = selectedCities[indexPath.row]
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }

  //   MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "serchCitySegue" {
      let dest = segue.destination as? SearchCityViewController
      dest?.delegate = self
    }
  }

}
