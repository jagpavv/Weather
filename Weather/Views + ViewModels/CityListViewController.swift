import UIKit
import RxSwift
import RxCocoa

class CityListViewController: UIViewController, StoryboardInstantiable {

  @IBOutlet weak var tableView: UITableView!
  private let searchController = UISearchController(searchResultsController: nil)

  var viewModel: CityListViewModel! = nil
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
      .bind(to: tableView.rx.items(cellIdentifier: CityListTableViewCell.identifier, cellType: CityListTableViewCell.self)) { (row, city, cell) in
        cell.fillCell(data: city)
      }
      .disposed(by: disposeBag)

    searchController.searchBar.rx.text.orEmpty
      .throttle(.seconds(3), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: viewModel.searchKeyword)
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(City.self)
      .do(onNext: { [unowned self] indexPath in
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        self.tableView.deselectRow(at: indexPath, animated: true)
      })
      .map { $0.id }
      .bind(to: viewModel.selectedCityId)
      .disposed(by: disposeBag)
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
