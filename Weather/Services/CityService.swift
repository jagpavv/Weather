
import Foundation
import RxSwift
import RxCocoa

protocol CityServiceProtocol {
  func getCities() -> Single<[City]>
}

class CityService: CityServiceProtocol {

  private let kCityListKey = "cityList"

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  func getCities() -> Single<[City]> {
    return Single.create { observer in
      let disposable = Disposables.create()

      var cities: [City] = []

      if let citiesData = UserDefaults.standard.object(forKey: self.kCityListKey) as? Data {
        cities = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(citiesData) as! [City]
      } else if let asset = NSDataAsset(name: self.kCityListKey, bundle: Bundle.main) {
        do {
          if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
            json.forEach { (cityJson) in
              DispatchQueue.global(qos: .background).async {
                cities.append(City(json: cityJson))
              }
            }
            let encodedData: Data = try! NSKeyedArchiver.archivedData(withRootObject: cities, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: self.kCityListKey)
          }
        }
      }
      observer(.success(cities))
      return disposable
    }
  }
}
