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

  struct My {
    static var cellSnapShot: UIView? = nil
  }

  struct Path {
    static var initialIndexPath: IndexPath? = nil
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
  var selectedCities: [String] {
    get {
      var cities = [String]()
      if let city = UserDefaults.standard.stringArray(forKey: kSelectedCitiesKey) {
        cities = city
      }
      return cities
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kSelectedCitiesKey)
      UserDefaults.standard.synchronize()
    }
  }

  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private let tempImageName = "01d"

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.getCityList()
    let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
    self.tableView.addGestureRecognizer(longpress)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Methods
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
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(200)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedCities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel?.text = selectedCities[indexPath.row]
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.selectedCities.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .right)
      tableView.reloadData()
    }
  }
  // add recognizer -> addTarget (target-action pattern) -> state object's current state
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
        self.selectedCities.swapAt((indexPath?.row)!, (Path.initialIndexPath?.row)!)
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
