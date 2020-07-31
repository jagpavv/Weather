import UIKit
import Foundation
import CoreLocation

extension Date {
  var millisecondsSince1970:Int {
    return Int((self.timeIntervalSince1970 * 1000.0).rounded())
  }
}

class MainViewController: UIViewController {

  struct My {
    static var cellSnapShot: UIView? = nil
  }

  struct Path {
    static var initialIndexPath: IndexPath? = nil
  }

  private let viewModel = WeatherViewModel()
  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.weatherResult.bind { _ in
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }

    viewModel.getCityList()
    viewModel.cityList.bind { [weak self] cityList in
      DispatchQueue.main.async {
        self?.addButton.isEnabled = !cityList.isEmpty
      }
    }

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh(refreshControl:)), for: UIControl.Event.valueChanged)
    tableView.refreshControl = refreshControl
  }

  func startAnimatimgIndicator() {
    DispatchQueue.main.async {
      self.indicator.center = self.view.center
      self.indicator.startAnimating()
      self.indicator.hidesWhenStopped = false
      self.view.addSubview(self.indicator)
    }
  }

  func stopAnimatimgIndicator() {
    DispatchQueue.main.async {
      self.indicator.stopAnimating()
      self.indicator.hidesWhenStopped = true
      self.indicator.removeFromSuperview()
    }
  }

  @objc func refresh(refreshControl: UIRefreshControl) {
    viewModel.getWeather()
  }

  //   MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "searchCitySegue" {
      let dest = segue.destination as? SearchCityViewController
      dest?.delegate = self
    }
  }
}

// MARK: - SearchCityDelegate
extension MainViewController: SearchCityDelegate {

  var searchCityList: [City]? {
    return viewModel.cityList.value
  }

  func searchCitySelected(cityID: Int) {
    guard !viewModel.selectedCityIDs.contains(cityID) else { return }
    viewModel.selectedCityIDs.append(cityID)
    viewModel.getWeather()
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(200)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.weatherResult.value?.list.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: MainViewCell.identifier, for: indexPath) as! MainViewCell
    if let weather = viewModel.weatherResult.value?.list[indexPath.row] {
      cell.fillCell(data: weather)
    }
    return cell
  }
}

extension MainViewController: WeatherSearchProtocol {
  func startLoading() {
    startAnimatimgIndicator()
  }

  func updateWithWeathers() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func finishLoading() {
    stopAnimatimgIndicator()

    DispatchQueue.main.async {
      self.tableView.refreshControl?.endRefreshing()
    }
  }
}
