import Foundation
import RxSwift
import RxCocoa

protocol WeatherServiceProtocol {
  var isLoading: BehaviorRelay<Bool> { get }

  func getWeather(cityIDs: [String]) -> Single<WeatherResult>
}

class WeatherService: WeatherServiceProtocol {
  private let OpenWeatherAPIKey = "4c8b3b461a4559a8ac0c397de4b3aaaf"
  private var baseURL = "http://api.openweathermap.org"
  private var path = "/data/2.5/group"

  private var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

  func getWeather(cityIDs: [String]) -> Single<WeatherResult> {

    return Single.create { [weak self] singleObserver in
      let disposable = Disposables.create()

      let cities = cityIDs.map { String($0) }.joined(separator: ",")
      guard !cities.isEmpty else {
        singleObserver(.success(WeatherResult(list: [], cnt: 0)))
        return disposable
      }

      guard let self = self,
        var components = URLComponents(string: self.baseURL + self.path) else {
          singleObserver(.error(NSError()))
          return disposable
      }
      components.queryItems = [URLQueryItem(name: "id", value: cities),
                               URLQueryItem(name: "units", value: "metric"),
                               URLQueryItem(name: "APPID", value: self.OpenWeatherAPIKey)]

      guard let url = components.url else {
        singleObserver(.error(NSError()))
        return disposable
      }
      print("url", url)
      let request = URLRequest(url: url)

      self.isLoading.accept(true)
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        self.isLoading.accept(false)
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

/*
 let response = Observable.from([repo])
 .map { urlString -> URL in
 return URL(string: "https://api.github.com/repos/\(urlString)/events")! }
 .map { url -> URLRequest in
   return URLRequest(url: url)
 }
 .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> // here need to catch error code - Chapter14
 in
 return URLSession.shared.rx.response(request: request) }

 .share(replay: 1, scope: .whileConnected)
 */
