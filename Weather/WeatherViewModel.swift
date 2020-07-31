
import Foundation
import UIKit.NSDataAsset

class WeatherViewModel {

  private let kSelectedCityIDsKey = "selectedCityIDs"
  private let kCityListKey = "cityList"

  private let weatherSearchService = WeatherSearchService()
  var weatherResult: Box<WeatherResult?> = Box(nil)

//  var selectedCityIDs: Box<[Int]> {
//    get {
//      UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? Box<[Int]> ?? Box([Int]())
//    }
//    set(newValue) {
//      UserDefaults.standard.set(newValue, forKey: kSelectedCityIDsKey)
//    }
//  }

  var selectedCityIDs: [Int] {
    get {
      return UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? [Int] ?? [Int]()
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kSelectedCityIDsKey)
    }
  }

  var idString: String? {
    return selectedCityIDs.map{ String($0) }.joined(separator: ",")
  }

  let cityList: Box<[City]> = Box([City]())


  init() {
    getWeather()
    getCityList()
  }

    func getWeather() {
      guard let idString = idString else { return }
      weatherSearchService.getWeather(cityIDString: idString) { result in
        switch result {
        case .success(let weatherResult):
          self.weatherResult.value = weatherResult
        case .failure(let error):
          print("error", error.localizedDescription)
        }
      }
    }

  func getCityList() {

    DispatchQueue.global(qos: .background).async {

      if let citiesData = UserDefaults.standard.object(forKey: self.kCityListKey) as? Data {
        self.cityList.value = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(citiesData) as! [City]
      } else if let asset = NSDataAsset(name: "cityList", bundle: Bundle.main) {
        do {
          if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
            json.forEach { (cityJson) in
              self.cityList.value.append(City(json: cityJson))
            }
            let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: self.cityList, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: self.kCityListKey)
            UserDefaults.standard.synchronize()
          }
        }
      }
    }
  }
}
