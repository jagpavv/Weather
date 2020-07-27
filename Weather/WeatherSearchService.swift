import Foundation

let OpenWeatherAPIKey = "4c8b3b461a4559a8ac0c397de4b3aaaf"

class WeatherSearchService {

  private var baseURL = "http://api.openweathermap.org"
  private var path = "/data/2.5/group"

  private var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  func getWeather(cityIDString: String, completion: @escaping (Result<WeatherResult, Error>) -> Void) {

    guard var components = URLComponents(string: baseURL + path) else { return }
    components.queryItems = [URLQueryItem(name: "id", value: cityIDString),
                             URLQueryItem(name: "units", value: "metric"),
                             URLQueryItem(name: "APPID", value: OpenWeatherAPIKey)]

    guard let url = components.url else { return }
    let request = URLRequest(url: url)

    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }

      guard let data = data else { return }
      do {
        let decoded = try self.jsonDecoder.decode(WeatherResult.self, from: data)
        completion(.success(decoded))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
}
