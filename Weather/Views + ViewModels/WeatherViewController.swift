import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var tableView: UITableView!
  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

  var viewModel: WeatherViewModelProtocol! = nil
  weak var coordinator: AppCoordinator?
  private let disposeBag = DisposeBag()

  private lazy var callOnce: Void = {
    bind()
  }()

  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    _ = callOnce
  }

  private func bind() {

    viewModel.weathers
      .bind(to: tableView.rx.items(cellIdentifier: WeatherTableViewCell.identifier, cellType: WeatherTableViewCell.self)) { (row, weatherInfo, cell) in
        cell.fillCell(data: weatherInfo)
      }
      .disposed(by: disposeBag)

    // load weather data only once
    viewModel.weathers
      .filter { $0.isEmpty }
      .map { _ in }
      .bind(to: viewModel.requestWeather)
      .dispose()

    viewModel.isLoading
      .bind(to: indicator.rx.isAnimating)
      .disposed(by: disposeBag)
  }

  func setUI() {
    tableView.rowHeight = 60

    view.addSubview(indicator)
    indicator.center = self.view.center
  }
}

//// MARK: - Navigation
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "searchCitySegue" {
//      let dest = segue.destination as? SearchCityViewController
//      dest?.delegate = self
////      dest?.completionHandlers = { [weak self] id in
////        self?.viewModel.addCity(id: id)
////        print("completionHandlers", id)
////      }
//    }
//  }
//}
//
//extension WeatherViewController: SearchCityDelegate {
//  func searchCityDelegateSelectedCity(id: Int) {
//
//    viewModel.selectedCitySubject.onNext(id)
//
//    print(id)
//  }
//}
