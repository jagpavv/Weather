
import Foundation
import RxSwift
import RxCocoa

protocol CityViewModelProtocol {
  // Output
  var cities: BehaviorSubject<[City]> { get }

  // Input
  var searchKeyword: PublishSubject<String> { get }

}

class CityViewModel: CityViewModelProtocol {

  private let allCities: BehaviorSubject<[City]> = BehaviorSubject(value: [])

  let cities: BehaviorSubject<[City]> = BehaviorSubject(value: [])

  let searchKeyword: PublishSubject<String> = PublishSubject()

  let cityService: CityServiceProtocol
  let disposeBag = DisposeBag()

  init(service: CityServiceProtocol) {
    self.cityService = service
    bind()
  }

  func bind() {

    allCities
      .bind(to: cities)
      .disposed(by: disposeBag)

    cities
      .subscribe(onNext: { cities in
        print(cities.count)
      })
      .disposed(by: disposeBag)

    searchKeyword
      .map { $0.lowercased() }
      .withLatestFrom(allCities) { (keyword: $0, cities: $1) }
      .map { event in
        event.cities.filter { city in
          event.keyword.isEmpty
            ? true
            : city.name.lowercased().contains(event.keyword)
        }
      }
      .bind(to: cities)
      .disposed(by: disposeBag)

    cityService.getCities()
      .subscribe(onSuccess: { [unowned self] cities in
        self.allCities.onNext(cities)
      })
      .dispose()
  }
}
