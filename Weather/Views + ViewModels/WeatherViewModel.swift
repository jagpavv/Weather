
import Foundation
import RxSwift
import RxCocoa

protocol WeatherViewModelProtocol {
  // Output
  var weathers: BehaviorSubject<[WeatherInfo]> { get }
  var isLoading: BehaviorRelay<Bool> { get }

  // Input
  var requestWeather: PublishSubject<Void> { get }
//  var selectedCity: PublishSubject<Int> { get } // addCity
  var addCitySelected: PublishSubject<Void> { get }
  var weatherSelected: PublishSubject<WeatherInfo> { get }
}

class WeatherViewModel: WeatherViewModelProtocol {
  private let kSelectedCityIDsKey = "selectedCityIDs"
  private let weatherService: WeatherServiceProtocol
  private let coordinator: Coordinator

  let weathers: BehaviorSubject<[WeatherInfo]> = BehaviorSubject(value: [])
  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  let selectedCity: PublishSubject<Int> = PublishSubject()
  let requestWeather: PublishSubject<Void> = PublishSubject()
  let addCitySelected: PublishSubject<Void> = PublishSubject()
  let weatherSelected: PublishSubject<WeatherInfo> = PublishSubject()

  let disposeBag = DisposeBag()

  private var selectedCities: [Int] {
    get {
      return UserDefaults.standard.object(forKey: kSelectedCityIDsKey) as? [Int] ?? [Int]()
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kSelectedCityIDsKey)
    }
  }

  init(service: WeatherServiceProtocol, coordinator: Coordinator) {
    self.weatherService = service
    self.coordinator = coordinator

    bind()
  }

  private func bind() {
    print("selectedCities", selectedCities)

    weatherService.isLoading
      .bind(to: isLoading)
      .disposed(by: disposeBag)

    let requeset = requestWeather
      .map { self.selectedCities }
      .share()

    requeset
      .filter { !$0.isEmpty }
      .map { _ in []}
      .bind(to: weathers)
      .disposed(by: disposeBag)

    requeset
      .filter { !$0.isEmpty }
      .map { $0.map { String($0) }.joined(separator: ",") }
      .flatMap { cities in
        self.weatherService.getWeather(cityIDString: cities)
      }
      .map { $0.list }
      .bind(to: weathers)
      .disposed(by: disposeBag)

    addCitySelected
      .subscribe { _ in
        self.coordinator.trigger(route: .cityList)
      }.disposed(by: disposeBag)

    weatherSelected
      .subscribe(onNext: { weather in
        self.coordinator.trigger(route: .weatherDetail(weather: weather))
      })
      .disposed(by: disposeBag)
  }
}
