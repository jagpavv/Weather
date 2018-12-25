import SwiftyJSON
import Foundation

struct Main {
  let temp: Float

  let pressure: Int?
  let temp_max: Float?
  let temp_min: Float?
  let humidity: Int?

  init(json: JSON) {
    self.temp = json["temp"].floatValue
    self.pressure = json["pressure"].int
    self.temp_max = json["temp_max"].float
    self.temp_min = json["temp_min"].float
    self.humidity = json["humidity"].int
  }
}
