import SwiftyJSON
import Foundation

struct WeatherInfo {
  let id: Int
  let name: String
  let main: Main

  let coord: Coord?
  let cod: Int?
  let sys: Sys?
  let base: String?
  let dt: Int?
  let wind: Wind?
  let weather: [Weather]?
  let clouds: Clouds?
  let visibility: Int?

  init(json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    self.main = Main(json: json["main"])

    self.coord = Coord(json: json["coord"])
    self.cod = json["cod"].int
    self.sys = Sys(json: json["sys"])
    self.base = json["base"].string
    self.dt = json["dt"].int
    self.wind = Wind(json: json["wind"])

//    for json in json["weather"].arrayValue {
//      weather?.append(Weather(json: json))
//    }
    self.weather = json["weather"].array?.map { Weather(json: $0) }

    self.clouds = Clouds(json: json["clouds"])
    self.visibility = json["visibility"].intValue
  }
}
