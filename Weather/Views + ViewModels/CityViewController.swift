import UIKit
//
//protocol SearchCityDelegate: class {
//  func searchCityDelegateSelectedCity(id: Int)
//}
//
class CityViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var tableView: UITableView!

//  private let viewModel: SearchCityViewModelProtocol = SearchCityViewModel()
//  private let cellIdentifier = "serchedCityDisplayCell"
//  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
//
//  weak var delegate: SearchCityDelegate?
////  var completionHandlers: ((Int) -> Void)?
//
//  @IBOutlet weak var tableView: UITableView!
//  @IBOutlet weak var searchBar: UISearchBar!
//
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Cities"
    view.backgroundColor = .red
//    viewModel.cities.bind { cities in
//      print("cities count:", cities.count)
//      DispatchQueue.main.async {
//        self.tableView.reloadData()
//      }
    }
//
//    viewModel.filteredCity.bind { filteredCity in
//      print("viewdidload filteredCity", filteredCity.count)
//      DispatchQueue.main.async {
//        self.tableView.reloadData()
//      }
//    }
//  }
//
//  override func viewDidAppear(_ animated: Bool) {
//    super.viewDidAppear(animated)
//    searchBar.becomeFirstResponder()
//  }
//
//  func startAnimatimgIndicator() {
//    DispatchQueue.main.async {
//      self.indicator.center = self.view.center
//      self.indicator.startAnimating()
//      self.indicator.hidesWhenStopped = false
//      self.view.addSubview(self.indicator)
//    }
//  }
//
//  func stopAnimatimgIndicator() {
//    DispatchQueue.main.async {
//      self.indicator.stopAnimating()
//      self.indicator.hidesWhenStopped = true
//      self.indicator.removeFromSuperview()
//    }
//  }
//}
//
//// MARK:- UITableViewDataSource, UITableViewDelegate
//extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return searchBar.text?.isEmpty ?? true ? 0 : viewModel.filteredCity.value.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
//    let city = viewModel.filteredCity.value[indexPath.row]
//    cell.textLabel?.text = city.name + ", " + city.country
//    return cell
//  }
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////    guard let completionHandlers = completionHandlers else { return }
////    completionHandlers(viewModel.filteredCity.value[indexPath.row].id)
//    delegate?.searchCityDelegateSelectedCity(id: viewModel.filteredCity.value[indexPath.row].id)
//    dismiss(animated: true)
//  }
//}
//
//// MARK:- UIScrollViewDelegate
//extension SearchCityViewController: UIScrollViewDelegate {
//  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//    guard searchBar.isFirstResponder else { return }
//    searchBar.resignFirstResponder()
//  }
//}
//
//// MARK:- UISearchBarDelegate
//extension SearchCityViewController: UISearchBarDelegate {
//  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//    searchBar.text = ""
//    dismiss(animated: true, completion: nil)
//  }
//
//  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
////    startAnimatimgIndicator()
//    viewModel.searchBarUpdated(text: searchBar.text, isTextEmpty: searchText.isEmpty)
////    stopAnimatimgIndicator()
//  }
}
