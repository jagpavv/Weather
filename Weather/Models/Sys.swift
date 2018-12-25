import SwiftyJSON
import Foundation

struct Sys {
  let id: Int

  let message: Float?
  let type: Int?
  let sunset: Int?
  let sunrise: Int?
  let country: String?

  init?(json: JSON?) {
    guard let json = json else { return nil }
    self.id = json["id"].intValue
    self.message = json["message"].float
    self.type = json["type"].int
    self.sunset = json["sunset"].int
    self.sunrise = json["sunrise"].int
    self.country = json["country"].string
  }
}
