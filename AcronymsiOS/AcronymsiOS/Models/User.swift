

import Foundation

final class User: Codable {
  var id: UUID?
  var name: String
  var username: String

  init(name: String, username: String) {
    self.name = name
    self.username = username
  }
}

final class CreateUser: Codable {
  var id: UUID?
  var name: String
  var username: String
  var password: String?
  var email: String?

  init(name: String, username: String, password: String, email: String) {
    self.name = name
    self.username = username
    self.password = password
    self.email = email
  }
}
