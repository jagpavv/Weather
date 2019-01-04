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

class MainViewController: UIViewController {

  struct My {
    static var cellSnapShot: UIView? = nil
  }

  struct Path {
    static var initialIndexPath: IndexPath? = nil
  }

  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?id="
  private let openWeatherMapAPIKey = "&APPID=4c8b3b461a4559a8ac0c397de4b3aaaf"
  private let kSelectedCityIDsKey = "selectedCityIDs"
  private let kCityListKey = "cityList"

  private var weatherInfos = [WeatherInfo]()
  private var cityList = [City]()
  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  private var selectedCityIDs: [Int] {
    get {
      return UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? [Int] ?? [Int]()
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kSelectedCityIDsKey)
      UserDefaults.standard.synchronize()
    }
  }

  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))

    getCityList()
    tableView.addGestureRecognizer(longpress)

    print(selectedCityIDs)
    selectedCityIDs.forEach { cityID in
      self.getWeather(from: cityID)
    }
  }

  // MARK: - Parsing data Methods
  private func getCityList() {
    let now = Date().millisecondsSince1970

    if let citiesData = UserDefaults.standard.object(forKey: kCityListKey) as? Data {
      cityList = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(citiesData) as! [City]
      print("mili1: \(Date().millisecondsSince1970 - now)")
    } else if let asset = NSDataAsset(name: "cityList", bundle: Bundle.main) {
      do {
        if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
          for cityJson in json {
            let city = City(json: cityJson)
            cityList.append(city)
          }
          print("mili2: \(Date().millisecondsSince1970 - now)")
          let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: cityList, requiringSecureCoding: false)
          UserDefaults.standard.set(encodedData, forKey: kCityListKey)
          UserDefaults.standard.synchronize()
        }
      }
    }
    self.addButton.isEnabled = !cityList.isEmpty
    print("cityList.count: \(cityList.count)")
  }

  private func getWeather(from cityID: Int) {
    let url = openWeatherMapBaseURL + "\(cityID)" + openWeatherMapAPIKey
    //    print(url)
    Alamofire.request(url, method: .get).validate().responseData { response in
      switch response.result {
      case.success(let data):
        guard let weatherInfo = try? self.jsonDecoder.decode(WeatherInfo.self, from: data) else { return }
        self.weatherInfos.append(weatherInfo)
        self.sort2()
        print("Got response from API : \(weatherInfo.id)")
        self.tableView.reloadData()
      case .failure(let error):
        print(error)
      }
    }
  }

  func sort2() {
    weatherInfos = weatherInfos.sorted { selectedCityIDs.firstIndex(of: $0.id) ?? -1 < selectedCityIDs.firstIndex(of: $1.id) ?? -1 }
  }

  func sort() {

    func findWeatherInfo(by cityID: Int) -> WeatherInfo? {
      for info in weatherInfos {
        if info.id == cityID {
          return info
        }
      }
      return nil
    }

    var sortedWeatehrInfos = [WeatherInfo]()

    selectedCityIDs.forEach { (id) in
      if let w = findWeatherInfo(by: id) {
        sortedWeatehrInfos.append(w)
      }
    }

    weatherInfos = sortedWeatehrInfos
  }

  @objc func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
    let longpress = gestureRecognizer as! UILongPressGestureRecognizer
    let state = longpress.state
    let locationInView = longpress.location(in: self.tableView)
    let indexPath = self.tableView.indexPathForRow(at: locationInView)

    switch state {
    case .began:
      if indexPath != nil {
        Path.initialIndexPath = indexPath
        let cell = self.tableView.cellForRow(at: indexPath!) as! MainViewCell
        My.cellSnapShot = snapshopOfCell(inputView: cell)
        var center = cell.center
        My.cellSnapShot?.center = center
        My.cellSnapShot?.alpha = 0.0
        self.tableView.addSubview(My.cellSnapShot!)

        UIView.animate(withDuration: 0.25, animations: {
          center.y = locationInView.y
          My.cellSnapShot?.center = center
          My.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
          My.cellSnapShot?.alpha = 0.98
          cell.alpha = 0.0
        }, completion: { (finished) -> Void in
          if finished {
            cell.isHidden = true
          }
        })
      }
    case .changed:
      var center = My.cellSnapShot?.center
      center?.y = locationInView.y
      My.cellSnapShot?.center = center!
      if (indexPath != nil && indexPath != Path.initialIndexPath) {
        self.selectedCityIDs.swapAt((indexPath?.row)!, (Path.initialIndexPath?.row)!)
        self.tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
        Path.initialIndexPath = indexPath
      }
    default:
      let cell = self.tableView.cellForRow(at: indexPath!) as! MainViewCell
      cell.isHidden = false
      cell.alpha = 0.0
      UIView.animate(withDuration: 0.25, animations: {
        My.cellSnapShot?.center = cell.center
        My.cellSnapShot?.transform = .identity
        My.cellSnapShot?.alpha = 0.0
        cell.alpha = 1.0
      }, completion: { (finished) -> Void in
        if finished {
          Path.initialIndexPath = nil
          My.cellSnapShot?.removeFromSuperview()
          My.cellSnapShot = nil
        }
      })
    }
  }

  func snapshopOfCell(inputView: UIView) -> UIView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
    inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    let cellSnapShot: UIView = UIImageView(image: image)
    cellSnapShot.layer.masksToBounds = false
    cellSnapShot.layer.cornerRadius = 0.0
    cellSnapShot.layer.shadowOffset = CGSize(width: -0.5, height: 0.0)
    cellSnapShot.layer.shadowOpacity = 0.4
    return cellSnapShot
  }

  //   MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "searchCitySegue" {
      let dest = segue.destination as? SearchCityViewController
      dest?.delegate = self
    }
  }
}

// MARK: - SearchCityDelegate
extension MainViewController: SearchCityDelegate {

  var searchCityList: [City]? {
    return cityList
  }

  func searchCitySelected(cityID: Int) {
    guard !selectedCityIDs.contains(cityID) else { return }

    selectedCityIDs.append(cityID)
    getWeather(from: cityID)
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(200)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherInfos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: MainViewCell.identifier, for: indexPath) as! MainViewCell
    cell.fillCell(data: weatherInfos[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.selectedCityIDs.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .right)
      tableView.reloadData()
    }
  }
}
