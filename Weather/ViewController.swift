//import UIKit
//import Foundation
//import Alamofire
//import SwiftyJSON
//import CoreLocation
//import NVActivityIndicatorView
//
//class ViewController: UIViewController, CLLocationManagerDelegate {
//
//  // MARK: - Properties
//  let gradientLayer: CAGradientLayer = CAGradientLayer()
//  let apiKey = "4c8b3b461a4559a8ac0c397de4b3aaaf"
//
//  // defualt value
//  var lat = 52.5200
//  var lon = 13.4050
//  var activityIndicator: NVActivityIndicatorView!
//  let locationManager = CLLocationManager()
//
//  // MARK: IBOutlets
//  @IBOutlet weak var locationLabel: UILabel!
//  @IBOutlet weak var dayLabel: UILabel!
//  @IBOutlet weak var conditionImageView: UIImageView!
//  @IBOutlet weak var conditionLabel: UILabel!
//  @IBOutlet weak var temperatueLabel: UILabel!
//  @IBOutlet weak var backgroundView: UIView!
//
//  // MARK: Life Cycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    backgroundView.layer.addSublayer(gradientLayer)
//
//    let indicatorSize: CGFloat = 70
//    let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
//    activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
//    activityIndicator.backgroundColor = UIColor.black
//    view.addSubview(activityIndicator)
//
//    locationManager.requestWhenInUseAuthorization()
//    activityIndicator.startAnimating()
//    if CLLocationManager.locationServicesEnabled() {
//      locationManager.delegate = self
//      locationManager.desiredAccuracy = kCLLocationAccuracyBest
//      locationManager.startUpdatingLocation()
//    }
//  }
//
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    setBlueGradientBackground()
//  }
//
//  // MARK: - Methods
//  // MARK: Custom Method
//  func setBlueGradientBackground() {
//    let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
//    let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
//    gradientLayer.frame = view.bounds
//    gradientLayer.colors = [topColor, bottomColor]
//  }
//
//  func setGrayGradientBackground() {
//    let topColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 72.0/255/0, alpha: 1.0).cgColor
//    let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
//    gradientLayer.frame = view.bounds
//    gradientLayer.colors = [topColor, bottomColor]
//  }
//
//  func getWeather(lat: Double, lon: Double) {
//    Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&apiKey=\(apiKey)").responseJSON { (response) in
//      self.activityIndicator.stopAnimating()
//      if let responseStr = response.result.value {
//        let jsonResponse = JSON(responseStr)
//        let jsonWeather = jsonResponse["weather"].array![0]
//        let jsonTemp = jsonResponse["main"]
//        let iconName = jsonWeather["icon"].stringValue
//
//        self.locationLabel.text = jsonResponse["name"].stringValue
//        self.conditionImageView.image = UIImage(named: iconName)
//        self.conditionLabel.text = jsonWeather["main"].stringValue
//        self.temperatueLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
//
//        let date = Date()
//        let dateFormatter: DateFormatter = {
//          let formatter: DateFormatter = DateFormatter()
//          formatter.dateFormat = "EEEE"
//          return formatter
//        }()
//        self.dayLabel.text = dateFormatter.string(from: date)
//
//        let suffix = iconName.suffix(1)
//        if suffix == "n" {
//          self.setGrayGradientBackground()
//        } else {
//          self.setBlueGradientBackground()
//        }
//      }
//    }
//  }
//
//  // MARK: Delegate Method
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    let location = locations[0]
//    lat = location.coordinate.latitude
//    lon = location.coordinate.longitude
//
//    getWeather(lat: lat, lon: lon)
//    self.locationManager.stopUpdatingLocation()
//  }
//
//  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//    print(error.localizedDescription)
//  }
//}
