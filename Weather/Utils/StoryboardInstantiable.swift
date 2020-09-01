
import UIKit

protocol StoryboardInstantiable {
  static func initFromStoryboard(with: String) -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
  static func initFromStoryboard(with: String) -> Self {
    let storyboardName = String(describing: self)
    let storyboardIdentifier = String(describing: self)
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
  }
}
