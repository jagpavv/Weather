import UIKit
import Foundation

protocol SearchCityDelegate {
  var searchCityList: [String]? { get }
  func searchCitySelected(city: String)
}

class SearchCityViewController: UIViewController {

  let cellIdentifier = "serchedCityDisplayCell"

  var delegate: SearchCityDelegate?
  var filteredCity = [String]()

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
        return city.lowercased().contains(searchText.lowercased())
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
