
import Foundation

protocol WeatherViewModelProtocol {
  // Output
  var weatherResult: Box<WeatherResult> { get }
  var isLoading: Box<Bool> { get }

  // Input
  func addCity(id: Int)
  func getWeather()
}

class WeatherViewModel: WeatherViewModelProtocol {

  private let kSelectedCityIDsKey = "selectedCityIDs"
  private let weatherSearchService = WeatherSearchService()

  var weatherResult: Box<WeatherResult> = Box(WeatherResult(list: [], cnt: 0))
  var isLoading: Box<Bool> = Box(false)

  private var selectedCities: [Int] {
    get {
      return UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? [Int] ?? [Int]()
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kSelectedCityIDsKey)
    }
  }

  private var stringSelectedCities: String? {
    return selectedCities.map{ String($0) }.joined(separator: ",")
  }

  func addCity(id: Int) {
    guard !selectedCities.contains(id) else { return }
    selectedCities.append(id)
    getWeather()
  }

  func getWeather() {
    guard let stringSelectedCities = stringSelectedCities else { return }
    print("stringSelectedCities", stringSelectedCities)

    isLoading.value = true
    weatherSearchService.getWeather(cityIDString: stringSelectedCities) { result in
      self.isLoading.value = false
      switch result {
      case .success(let weatherResult):
        self.weatherResult.value = weatherResult
      case .failure(let error):
        print("error", error.localizedDescription)
      }
    }
  }
}
