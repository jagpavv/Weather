import UIKit
import Foundation

protocol SearchCityDelegate {
  var searchCityList: [City]? { get }
  func searchCitySelected(cityID: Int)
}

class SearchCityViewController: UIViewController {

  private let cellIdentifier = "serchedCityDisplayCell"
  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)


  var delegate: SearchCityDelegate?
  var filteredCity = [City]()

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    dismiss(animated: true, completion: nil)
  }

  func startAnimatimgIndicator() {
    indicator.center = view.center
    indicator.startAnimating()
    indicator.hidesWhenStopped = false
    view.addSubview(indicator)
  }
}

extension SearchCityViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    startAnimatimgIndicator()
    guard let cityList = delegate?.searchCityList else { return }

    if let searchText = searchBar.text, !searchText.isEmpty {
      filteredCity = cityList.filter { city in
        return city.name.lowercased().contains(searchText.lowercased())
      }
    }
    self.indicator.stopAnimating()
    self.indicator.hidesWhenStopped = true
    self.indicator.removeFromSuperview()
    tableView.reloadData()
  }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchBar.text?.isEmpty ?? true ? 0 : filteredCity.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
    let city = filteredCity[indexPath.row]
    cell.textLabel?.text = city.name + ", " + city.country
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.searchCitySelected(cityID: filteredCity[indexPath.row].id)
    dismiss(animated: true)
  }
}

extension SearchCityViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    guard searchBar.isFirstResponder else { return }
    searchBar.resignFirstResponder()
  }
}
