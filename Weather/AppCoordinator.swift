
import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  func start()
}

class AppCoordinator: Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

  private let weatherService = WeatherService()
//  private lazy var weatherViewModel = WeatherViewModel(service: weatherService)
  private lazy var weatherViewModel = WeatherViewModel(service: weatherService, coordinator: self)

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let weatherViewController = WeatherViewController.initFromStoryboard(with: "WeatherViewController")
//    weatherViewController.coordinator = self
    weatherViewController.viewModel = weatherViewModel
    navigationController.viewControllers = [weatherViewController]
  }

  func showCityViewController() {
    let cityViewController = CityViewController.initFromStoryboard(with: "CityViewController")
    navigationController.pushViewController(cityViewController, animated: true)
  }
}
