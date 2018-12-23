import Alamofire
import SwiftyJSON
import Foundation

struct WeatherInfo {
  let cityName: String?
  let temperature: Double?
  let icon: String?
  
  init(json: JSON) {
    self.cityName = json["name"].stringValue
    self.temperature = json["main"]["temp"].doubleValue
    self.icon = json["weather"][0]["icon"].stringValue
  }
}
