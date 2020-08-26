
import Foundation
import RxSwift

protocol WeatherViewModelProtocol {
  // Output
  var weathers: BehaviorSubject<[WeatherInfo]> { get }
//  var isLoading: BehaviorSubject<[Bool]> { get }

  // Input
  var requestWeather: PublishSubject<Void> { get }
  var selectedCity: PublishSubject<Int> { get }
}

class WeatherViewModel: WeatherViewModelProtocol {

  private let kSelectedCityIDsKey = "selectedCityIDs"
  private let weatherService: WeatherServiceProtocol

  let weathers: BehaviorSubject<[WeatherInfo]> = BehaviorSubject(value: [])

  let selectedCity: PublishSubject<Int> = PublishSubject()
  let requestWeather: PublishSubject<Void> = PublishSubject()
  let disposeBag = DisposeBag()

  private var selectedCities: [Int] {
    get {
      return UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? [Int] ?? [Int]()
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kSelectedCityIDsKey)
    }
  }

  init(service: WeatherServiceProtocol) {
    weatherService = service

    bind()
  }

  private func bind() {
    print("selectedCities", selectedCities)

    requestWeather
      .map { self.selectedCities }
      .map { $0.map { String($0) }.joined(separator: ",")
      }
      .flatMap { cities in
        self.weatherService.getWeatherSingle(cityIDString: cities)
      }
      .map { $0.list }
      .bind(to: weathers)
      .disposed(by: disposeBag)



//    selectedCity
//      .withLatestFrom(selectedCities) { (id: $0, idArray: $1) }
//      .filter{ !$1.contains($0) }
//      .map { (id: Int, _) in
//        [id]
//      } .withLatestFrom(selectedCities) { (newID: $0, exstingIDs: $1) }
//        .map { $1 + $0 }
//        .bind(to: selectedCities)
//        .disposed(by: disposeBag)
//
//    selectedCities
//      .map { ids in
//        ids.map { String($0) }.joined(separator: ",")
//      }.flatMap { cities in
//        self.weatherService.getWeatherSingle(cityIDString: cities)
//      }.map { $0.list }
//      .bind(to: weathers)
//      .disposed(by: disposeBag)
  }
}
