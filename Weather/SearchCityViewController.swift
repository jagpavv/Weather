import UIKit
import Foundation

protocol SearchCityDelegate {
//  var searchCityList: [String]? { get }
  func searchCityList() -> [String]?
  func searchCitySelected(city: String)
}

class SearchCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

  // MARK: - Properties
  let cellIdentifier = "serchedCityDisplayCell"
  let searchController = UISearchController(searchResultsController: nil)

  var delegate: SearchCityDelegate?
  var filteredCity = [String]()

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Methods
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setSearchController()
  }

  // MARK: SearchController Method
  func setSearchController() {
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Enter the city name"
    searchController.definesPresentationContext = true // when user navigates to another view controller, search bar does not remain on the screen.
    tableView.tableHeaderView = searchController.searchBar
  }

  func updateSearchResults(for searchController: UISearchController) {
    guard let cityList = delegate?.searchCityList() else { return }
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      filteredCity = cityList.filter { city in
        return city.lowercased().contains(searchText.lowercased())
      }
    }
    tableView.reloadData()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    dismiss(animated: true, completion: nil)
  }

  // MARK: - TableView Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredCity.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
    cell.textLabel?.text = filteredCity[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let selectedText = tableView.cellForRow(at: indexPath)?.textLabel?.text else { return }
    print("selectedText: \(selectedText)")
    delegate?.searchCitySelected(city: selectedText)
    dismiss(animated: true)
  }
}
