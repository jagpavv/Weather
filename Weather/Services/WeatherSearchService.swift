import Foundation
import RxSwift

protocol WeatherSearchServiceProtocol {
//  var isLoading: BehaviorSubject<Bool> { get }
  func getWeatherSingle(cityIDString: String) -> Single<WeatherResult>
}

let OpenWeatherAPIKey = "4c8b3b461a4559a8ac0c397de4b3aaaf"

class WeatherService: WeatherSearchServiceProtocol {

  private var baseURL = "http://api.openweathermap.org"
  private var path = "/data/2.5/group"

  private var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  let isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false) // BehaviorRelay

  func getWeatherSingle(cityIDString: String) -> Single<WeatherResult> {
    return Single.create { [weak self] singleObserver in
      let disposable = Disposables.create()

      guard let self = self,
            var components = URLComponents(string: self.baseURL + self.path) else {
        singleObserver(.error(NSError()))
        return disposable
      }
      components.queryItems = [URLQueryItem(name: "id", value: cityIDString),
                               URLQueryItem(name: "units", value: "metric"),
                               URLQueryItem(name: "APPID", value: OpenWeatherAPIKey)]

      guard let url = components.url else {
        singleObserver(.error(NSError()))
        return disposable
      }
      print("url", url)
      let request = URLRequest(url: url)

      self.isLoading.onNext(true)
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        self.isLoading.onNext(false)
        if let error = error {
          singleObserver(.error(error))
        }

        guard let data = data else { return }
        do {
          let decoded = try self.jsonDecoder.decode(WeatherResult.self, from: data)
          singleObserver(.success(decoded))
        } catch {
          singleObserver(.error(error))
        }
      }.resume()
      return disposable
    }
  }
}
