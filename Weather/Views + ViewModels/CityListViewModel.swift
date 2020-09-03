
import Foundation
import RxSwift
import RxCocoa

protocol CityListViewModelProtocol {
  // Output
  var cities: BehaviorSubject<[City]> { get }

  // Input
  var searchKeyword: PublishSubject<String> { get }
  var selectedCityId: PublishSubject<Int> { get }
}

protocol CitySelectionDelegate: class {
  func citySelectionDelegateDidSelectCity(id: Int)
}

class CityListViewModel: CityListViewModelProtocol {

  weak var delegate: CitySelectionDelegate?
  private let cityService: CityServiceProtocol
  private let coordinator: Coordinator

  private let allCities: BehaviorSubject<[City]> = BehaviorSubject(value: [])

  let cities: BehaviorSubject<[City]> = BehaviorSubject(value: [])

  let searchKeyword: PublishSubject<String> = PublishSubject()
  let selectedCityId: PublishSubject<Int> = PublishSubject()

  let disposeBag = DisposeBag()

  init(service: CityServiceProtocol, coordinator: Coordinator) {
    self.cityService = service
    self.coordinator = coordinator
    
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

    selectedCityId
      .subscribe(onNext: { id in
        self.delegate?.citySelectionDelegateDidSelectCity(id: id)
        self.coordinator.trigger(route: .back)
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
