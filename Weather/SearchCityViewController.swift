import UIKit
import Foundation

protocol SearchCityDelegate {
  var searchCityList: [City]? { get }
  func searchCitySelected(city: City)
}

class SearchCityViewController: UIViewController {

  let cellIdentifier = "serchedCityDisplayCell"

  var delegate: SearchCityDelegate?
  var filteredCity = [City]()

  @IBOutlet weak var tableView: UITableView!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    dismiss(animated: true, completion: nil)
  }
}

extension SearchCityViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let cityList = delegate?.searchCityList else { return }

    if let searchText = searchBar.text, !searchText.isEmpty {
      filteredCity = cityList.filter { city in
        return city.name.lowercased().contains(searchText.lowercased())
      }
    }
    tableView.reloadData()
  }
}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredCity.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
    let city = filteredCity[indexPath.row]
    cell.textLabel?.text = city.name + ", " + city.country
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.searchCitySelected(city: filteredCity[indexPath.row])
    dismiss(animated: true)
  }
}
