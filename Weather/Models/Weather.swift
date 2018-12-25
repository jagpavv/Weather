import SwiftyJSON
import Foundation

struct Weather {
  let id: Int
  let main: String
  let icon: String?
  let description: String?

  init(json: JSON) {
    self.id = json["id"].intValue
    self.main = json["main"].stringValue
    self.icon = json["icon"].string
    self.description = json["description"].string
  }
}
