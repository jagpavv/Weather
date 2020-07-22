import Foundation

struct WeatherInfo: Codable {
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
}
