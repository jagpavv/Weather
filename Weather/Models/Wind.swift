import SwiftyJSON
import Foundation

struct Wind {
  let speed: Double
  let deg: Double

  init?(json: JSON?) {
    guard let json = json else { return nil }
    self.speed = json["speed"].doubleValue
    self.deg = json["deg"].doubleValue
  }
}
