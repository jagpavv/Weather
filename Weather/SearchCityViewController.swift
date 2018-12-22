import UIKit
import Foundation

class SearchCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

  let cellIdentifier = "serchedCityDisplayCell"
  let searchController = UISearchController(searchResultsController: nil)
  let tempCityName2: [String] = ["AA", "AABB", "BB", "BBBAAA", "CCCC", "DDDDDDDD"]

  var filteredCity = [String]()

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setSearchController()
  }

  func setSearchController() {
    searchController.searchBar.delegate = self
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
//    searchController.hidesNavigationBarDuringPresentation = false
//    definesPresentationContext = true
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Enter the city name"
    tableView.tableHeaderView = searchController.searchBar
  }


  // Mandatory thing
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      filteredCity = tempCityName2.filter { city in
        return city.lowercased().contains(searchText.lowercased())
      }
    }
    tableView.reloadData()
  }


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 서치 결과가 없다면, return 0, 서치 결과가 있다면 reutnr 1
    return filteredCity.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: SearchCityViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! SearchCityViewCell
    cell.cityLabel?.text = filteredCity[indexPath.row]
    return cell
  }

//  func setSearchBar() {
//    searchBar.placeholder = "Enter the city name"
//  }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
