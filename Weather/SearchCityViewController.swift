import UIKit
import Foundation

// need to done 1)tapped cell 2) Searchbar clear button 3) search bar in the UINavigationItem position
class SearchCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {

  let cellIdentifier = "serchedCityDisplayCell"
  let unwindSegueIdentifier = "unwindToMainViewSegue"

  let searchController = UISearchController(searchResultsController: nil)

//  let tempCityName2: [String] = ["London", "Berlin", "Paris", "Hamburg", "Seoul", "Tokyo", "Taipei"]
  var cityArr: [String] = [String]()

  var filteredCity = [String]()
  var selectedCity: String!
  var selectedIndextPath: IndexPath!

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setSearchController()

    DispatchQueue.main.async {
      self.getCityList()
    }
  }

  // when and how to make fast loading...?
  func getCityList() {
    if let asset = NSDataAsset(name: "cityList", bundle: Bundle.main) {
      do {
        //        let json = try? JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments)
        if let json = try? JSONSerialization.jsonObject(with: asset.data, options: []) as! [[String: Any]] {
          for city in json {
            let a = city["name"] as! String
            cityArr.append(a)
            print(a)
          }
        }
      }
    }
  }

  // MARK: - Methods
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


    // another
//    var searchController: UISearchController!
//
//    self.navigationController?.navigationBar.prefersLargeTitles = true
//    self.navigationItem.title = "Search"
//    self.navigationItem.hidesSearchBarWhenScrolling = false
//    self.navigationItem.largeTitleDisplayMode = .always
//    searchController = UISearchController(searchResultsController: nil)
//    self.navigationItem.searchController = searchController
//    searchController.searchResultsUpdater = self
//
//    searchController.obscuresBackgroundDuringPresentation = false
//    searchController.searchBar.placeholder = "Search City"
//    navigationItem.searchController = searchController
//    definesPresentationContext = true

  }

  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
      filteredCity = cityArr.filter { city in
        return city.lowercased().contains(searchText.lowercased())
      }
    }
    tableView.reloadData()
  }


  // consider 'func updateSearchResults' move to extension?
// orginal code
//  func updateSearchResults(for searchController: UISearchController) {
//    if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//      filteredCity = tempCityName2.filter { city in
//        return city.lowercased().contains(searchText.lowercased())
//      }
//    }
//    tableView.reloadData()
//  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    dismiss(animated: true, completion: nil)
  }

  // MARK: TableView Methods
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
      let MainVC = segue.destination as! MainViewController
      MainVC.selectedCity.append(selectedCity)
      print("MainVC.tempCityArr: \(MainVC.selectedCity)")
    }
  }
}
