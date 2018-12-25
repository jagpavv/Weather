import SwiftyJSON
import Foundation

struct Clouds {
  let all: Int

  init?(json: JSON?) {
    guard let json = json else { return nil }
    self.all = json["all"].intValue
  }
}
