import UIKit
import Foundation

class SearchCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

  // MARK: - Properties
  let cellIdentifier = "serchedCityDisplayCell"
  let unwindSegueIdentifier = "unwindToMainViewSegue"
  let searchController = UISearchController(searchResultsController: nil)

  var cityArr: [String]?
  var filteredCity = [String]()
  var selectedCity: String!

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
    guard let cityArr = cityArr else { return }
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      filteredCity = cityArr.filter { city in
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
    selectedCity = selectedText
    performSegue(withIdentifier: unwindSegueIdentifier, sender: self)
    print("selectedText: \(selectedText)")
  }

  //   MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == unwindSegueIdentifier {
      guard let selectedCity = self.selectedCity else { return }
      let dest = segue.destination as! MainViewController
      dest.save(name: selectedCity)
    }
  }
}
