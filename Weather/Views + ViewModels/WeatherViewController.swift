import UIKit
import Foundation
import CoreLocation

class WeatherViewController: UIViewController {

  private let viewModel: WeatherViewModelProtocol = WeatherViewModel()
  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

  @IBOutlet weak var addButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

// MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    addButton.isEnabled = true

    viewModel.weatherResult.bind { weatherResult in
      print("weather results: \(weatherResult.cnt)")
      DispatchQueue.main.async {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
      }
    }

    viewModel.isLoading.bind { isLoading in
      if isLoading {
        self.startAnimatimgIndicator()
      } else {
        self.stopAnimatimgIndicator()
      }
    }

    viewModel.getWeather()

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

// MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "searchCitySegue" {
      let dest = segue.destination as? SearchCityViewController
      dest?.delegate = self
//      dest?.completionHandlers = { [weak self] id in
//        self?.viewModel.addCity(id: id)
//        print("completionHandlers", id)
//      }
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(200)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.weatherResult.value.list.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell: MainViewCell = tableView.dequeueReusableCell(withIdentifier: MainViewCell.identifier, for: indexPath) as! MainViewCell
    let weather = viewModel.weatherResult.value.list[indexPath.row]
    cell.fillCell(data: weather)
    return cell
  }
}

extension WeatherViewController: SearchCityDelegate {
  func searchCityDelegateSelectedCity(id: Int) {
    print(id)
  }
}
