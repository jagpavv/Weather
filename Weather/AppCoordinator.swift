
import UIKit

enum Route {
  case weatherList
  case weatherDetail(weather: WeatherInfo)
  case cityList(delegate: CitySelectionDelegate?)
  case back
}

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  func start()
  func trigger(route: Route)
}

class AppCoordinator: Coordinator {

  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

  private let weatherService = WeatherService()
  private lazy var weatherViewModel = WeatherViewModel(service: weatherService, coordinator: self)

  private let cityService = CityService()
  private lazy var cityListViewModel = CityListViewModel(service: cityService, coordinator: self)

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    trigger(route: .weatherList)
  }

  func trigger(route: Route) {
    switch route {
    case .weatherList:
      let weatherViewController = WeatherViewController.initFromStoryboard(with: "WeatherViewController")
      weatherViewController.viewModel = weatherViewModel
      navigationController.viewControllers = [weatherViewController]
    case .weatherDetail(let weather):
      print("detail", weather)
    case .cityList(let delegate):
      let cityListViewController = CityListViewController.initFromStoryboard(with: "CityListViewController")
      cityListViewModel.delegate = delegate
      cityListViewController.viewModel = cityListViewModel
      navigationController.pushViewController(cityListViewController, animated: true)
    case .back:
      navigationController.popViewController(animated: true)
    }
  }
}
