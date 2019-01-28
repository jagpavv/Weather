import Foundation

struct WeatherResult: Codable {
  let list: [WeatherInfo]
  let cnt: Int
}
