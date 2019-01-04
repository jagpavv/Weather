import Foundation

class City: NSObject, NSCoding {
  let id: Int
  let name: String
  let country: String

  init(id: Int, name: String, country: String) {
    self.id = id
    self.name = name
    self.country = country
  }

  init(json: [String: Any]) {
    self.id = json["id"] as! Int
    self.name = json["name"] as! String
    self.country = json["country"] as! String
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(id, forKey: "id")
    aCoder.encode(name, forKey: "name")
    aCoder.encode(country, forKey: "country")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let id = aDecoder.decodeInteger(forKey: "id")
    let name = aDecoder.decodeObject(forKey: "name") as! String
    let country = aDecoder.decodeObject(forKey: "country") as! String
    self.init(id: id, name: name, country: country)
  }
}
