import Foundation

struct Weather: Codable {
  let id: Int
  let main: String
  let icon: String?
  let description: String?
}
