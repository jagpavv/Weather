
import Foundation
import UIKit.NSDataAsset

protocol SearchCityViewModelProtocol {
  // Output
  var cities: Box<[City]> { get set }
  var filteredCity: Box<[City]> { get set }

  // Input
  func searchBarUpdated(text: String?, isTextEmpty: Bool)
  // func searchBarCancelButtonTapped(void...?) IBAction...?
  // func citySelected(cityID: Int)
}

class SearchCityViewModel: SearchCityViewModelProtocol {
  private let kCityListKey = "cityList"

  var cities: Box<[City]> = Box([])
  var filteredCity: Box<[City]> = Box([])

  init() {
    getCities()
  }

  func getCities() {
    if let citiesData = UserDefaults.standard.object(forKey: self.kCityListKey) as? Data {
      self.cities.value = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(citiesData) as! [City]
    } else if let asset = NSDataAsset(name: self.kCityListKey, bundle: Bundle.main) {
      do {
        if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
          json.forEach { (cityJson) in
            DispatchQueue.global(qos: .background).async {
              self.cities.value.append(City(json: cityJson))
            }
          }
          let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: self.cities, requiringSecureCoding: false)
          UserDefaults.standard.set(encodedData, forKey: self.kCityListKey)
          UserDefaults.standard.synchronize()
        }
      }
    }
  }

  func searchBarUpdated(text: String?, isTextEmpty: Bool) {
    if let searchText = text, !isTextEmpty {
      filteredCity.value = cities.value.filter{ city in
        print("filteredCity.value.count", filteredCity.value.count)
        return city.name.lowercased().contains(searchText.lowercased())
      }
    }
  }
}
