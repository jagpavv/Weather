
import Foundation
import RxSwift
import RxCocoa

protocol WeatherViewModelProtocol {
  // Output
  var weathers: BehaviorSubject<[WeatherInfo]> { get }
  var isLoading: BehaviorRelay<Bool> { get }

  // Input
  var requestWeather: PublishSubject<Void> { get }
  var addCitySelected: PublishSubject<Void> { get }
  var weatherSelected: PublishSubject<WeatherInfo> { get }
}

class WeatherViewModel: WeatherViewModelProtocol {

  private static let kSelectedCityIDsKey = "selectedCityIDs"
  private let weatherService: WeatherServiceProtocol
  private let coordinator: Coordinator

  private static let savedCities: [Int] = (UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? [Int]) ?? []

  private let cities: BehaviorRelay<[Int]> = BehaviorRelay(value: savedCities)

  let weathers: BehaviorSubject<[WeatherInfo]> = BehaviorSubject(value: [])
  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  let requestWeather: PublishSubject<Void> = PublishSubject()
  let addCitySelected: PublishSubject<Void> = PublishSubject()
  let weatherSelected: PublishSubject<WeatherInfo> = PublishSubject()

  let disposeBag = DisposeBag()

  init(service: WeatherServiceProtocol, coordinator: Coordinator) {
    self.weatherService = service
    self.coordinator = coordinator

    bind()
  }

  private func bind() {
    weatherService.isLoading
      .bind(to: isLoading)
      .disposed(by: disposeBag)

    cities
      .subscribe(onNext: { cities in
        UserDefaults.standard.set(cities, forKey: WeatherViewModel.kSelectedCityIDsKey)
      })
      .disposed(by: disposeBag)

    cities
      .map { cities in
        cities.map { String($0) }
      }
      .flatMap { [unowned self] cities in
        self.weatherService.getWeather(cityIDs: cities)
      }
      .map { $0.list }
      .bind(to: weathers)
      .disposed(by: disposeBag)

    addCitySelected
      .subscribe { _ in
        self.coordinator.trigger(route: .cityList(delegate: self))
      }
      .disposed(by: disposeBag)

    weatherSelected
      .subscribe(onNext: { weather in
        self.coordinator.trigger(route: .weatherDetail(weather: weather))
      })
      .disposed(by: disposeBag)
  }

}

extension WeatherViewModel: CitySelectionDelegate {
  func citySelectionDelegateDidSelectCity(id: Int) {
    cities.accept(cities.value + [id])
  }
}
