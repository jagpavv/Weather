import Foundation

struct Result: Codable {
  var list: [WeatherInfo]
  let cnt: Int
}
