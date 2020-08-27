import Foundation

struct WeatherInfo: Codable {
  let id: Int?
  let name: String?
  let main: Main?

  let dt: Int?
  let coord: Coord?
  let sys: Sys?
  let weather: [Weather]?
  let visibility: Int?
  let wind: Wind?
  let clouds: Clouds?
}
