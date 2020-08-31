import UIKit
import RxSwift
import RxCocoa
//
//protocol SearchCityDelegate: class {
//  func searchCityDelegateSelectedCity(id: Int)
//}
//
class CityViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var tableView: UITableView!
  private let searchController = UISearchController(searchResultsController: nil)

  var viewModel: CityViewModel! = nil
  private let disposeBag = DisposeBag()

  private lazy var callOnce: Void = {
    bind()
  }()

//  private let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

  override func viewDidLoad() {
    super.viewDidLoad()

    setSearchController()
    setNavigationBar()

    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    _ = callOnce
  }

  func bind() {

    viewModel.cities
      .bind(to: tableView.rx.items(cellIdentifier: CityTableViewCell.identifier, cellType: CityTableViewCell.self)) { (row, city, cell) in
        cell.fillCell(data: city)
      }
      .disposed(by: disposeBag)

    viewModel.cities
      .filter { $0.isEmpty }
      .map{ _ in }
      .bind(to: viewModel.requestCities)
      .dispose()
  }

  func setSearchController() {
    searchController.becomeFirstResponder()
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search city"
  }

  func setNavigationBar() {
    title = "Cities"
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true

    navigationItem.searchController = searchController
  }
}


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

