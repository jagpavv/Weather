import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import NVActivityIndicatorView

class ViewController: UIViewController {

  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var conditionLabel: UILabel!
  @IBOutlet weak var temperatueLabel: UILabel!
  @IBOutlet weak var backgroundView: UIView!

  let gradientLayer: CAGradientLayer = CAGradientLayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundView.layer.addSublayer(gradientLayer)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setBlueGradientBackground()
  }

  func setBlueGradientBackground() {
    let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
    let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [topColor, bottomColor]
  }

  func setGrayGradientBackground() {
    let topColor = UIColor(red: 155.0/255.0, green: 155.0/255.0, blue: 72.0/255/0, alpha: 1.0).cgColor
    let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [topColor, bottomColor]
  }



}

