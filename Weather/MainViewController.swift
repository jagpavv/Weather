import UIKit
import Foundation
import Alamofire
import CoreLocation
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  // MARK: - Properties
  private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?q="
  private let openWeatherMapAPIKey = "&APPID=4c8b3b461a4559a8ac0c397de4b3aaaf"
  let cellIdentifier = "weatherDisplayCell"

  var cityArr: [String] = [String]()
  var weatherInfos = [WeatherInfo]()

  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  var selectedCities: [NSManagedObject] = []
  let tempImageName = "01d"

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Methods
  @IBAction func unwindFromSearchCityView(_ segue: UIStoryboardSegue) {
    tableView.reloadData()
    print("successfully unwined form search city view Controller")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    DispatchQueue.main.async {
      self.getCityList()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData()

    for v in selectedCities {
      let city = v.value(forKey: "name") as! String
      getWeather(from: city)
      print("city, fetch from CoreData \(city)")
    }
  }

  func getCityList() {
    if let asset = NSDataAsset(name: "cityList", bundle: Bundle.main) {
      do {
        if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
          for city in json {
            let a = city["name"] as! String
            cityArr.append(a)
            print(a)
          }
        }
      }
    }
  }

  func getWeather(from city: String) {
    let url = openWeatherMapBaseURL + city + openWeatherMapAPIKey
    print(url)

    Alamofire.request(url, method: .get).validate().responseData { response in
      switch response.result {
      case.success(let data):
        guard let weatherInfo = try? self.jsonDecoder.decode(WeatherInfo.self, from: data) else { return }
        self.weatherInfos.append(weatherInfo)
        dump(self.weatherInfos)
      case .failure(let error):
        print(error)
      }
    }
  }

  // MARK: - Core Data Fetch and Save
  func save(name: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "SelectedCity", in: managedContext)!
    let selectedCity = NSManagedObject(entity: entity, insertInto: managedContext)
    selectedCity.setValue(name, forKey: "name")

    do {
      try managedContext.save()
      selectedCities.append(selectedCity)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  func fetchData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SelectedCity")
    do {
      selectedCities = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
  }

  // MARK: - Tableview Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedCities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! MainViewCell
    cell.cityLabel?.text = selectedCities[indexPath.row].value(forKey: "name") as? String
    cell.conditionImageView.image = UIImage(named: tempImageName)
    return cell
  }

  //   MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "serchCitySegue" {
      let dest = segue.destination as! SearchCityViewController
      dest.cityArr = cityArr
    }
  }
}
