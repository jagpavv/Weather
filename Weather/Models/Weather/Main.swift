import Foundation

struct Main: Codable {
  let temp: Float

  let pressure: Float?
  let tempMax: Float?
  let tempMin: Float?
  let humidity: Int?
  let seaLevel: Float?
  let grndLevel: Float?
}
