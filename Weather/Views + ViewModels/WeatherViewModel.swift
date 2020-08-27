
import Foundation
import RxSwift
import RxCocoa

protocol WeatherViewModelProtocol {
  // Output
  var weathers: BehaviorSubject<[WeatherInfo]> { get }
  var isLoading: BehaviorRelay<Bool> { get }

  // Input
  var requestWeather: PublishSubject<Void> { get }
  var selectedCity: PublishSubject<Int> { get }
}

class WeatherViewModel: WeatherViewModelProtocol {
  private let kSelectedCityIDsKey = "selectedCityIDs"
  private let weatherService: WeatherServiceProtocol

  let weathers: BehaviorSubject<[WeatherInfo]> = BehaviorSubject(value: [])
  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

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

    weatherService.isLoading
      .bind(to: isLoading)
      .disposed(by: disposeBag)

    requestWeather
      .map { self.selectedCities }
      .map { $0.map { String($0) }.joined(separator: ",")
      }
      .flatMap { cities in
        self.weatherService.getWeather(cityIDString: cities)
      }
      .map { $0.list }
      .bind(to: weathers)
      .disposed(by: disposeBag)
  }
}
