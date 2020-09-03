import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var tableView: UITableView!
  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
  private let addCityButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)

  var viewModel: WeatherViewModelProtocol! = nil
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

    tableView.rx.modelSelected(WeatherInfo.self)
      .do(onNext: { [unowned self] indexPath in
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: indexPath, animated: true)
      })
      .bind(to: viewModel.weatherSelected)
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

    addCityButton.rx.tap
      .bind(to: viewModel.addCitySelected)
      .disposed(by: disposeBag)
  }

  func setUI() {
    tableView.rowHeight = 60

    view.addSubview(indicator)
    indicator.center = self.view.center

    title = "Weather"
    self.navigationItem.rightBarButtonItem = addCityButton
  }
}
