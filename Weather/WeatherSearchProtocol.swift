
import Foundation

protocol WeatherSearchProtocol: class {
  func startLoading()
  func updateWithWeathers()
  func finishLoading()
}
