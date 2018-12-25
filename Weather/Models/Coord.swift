import SwiftyJSON
import Foundation

struct Coord {
  let lon: Double
  let lat: Double

  init?(json: JSON?) {
    guard let json = json else { return nil }
    self.lon = json["lon"].doubleValue
    self.lat = json["lat"].doubleValue
  }
}
