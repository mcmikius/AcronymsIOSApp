

import Foundation

enum AcronymUserRequestResult {
  case success(User)
  case failure
}

enum CategoryAddResult {
  case success
  case failure
}

struct AcronymRequest {
  let resource: URL

  init(acronymID: Int) {
    let resourceString = "http://localhost:8080/api/acronyms/\(acronymID)"
    guard let resourceURL = URL(string: resourceString) else {
      fatalError()
    }
    self.resource = resourceURL
  }

  func getUser(completion: @escaping (AcronymUserRequestResult) -> Void) {
    let url = resource.appendingPathComponent("user")
    let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let jsonData = data else {
        completion(.failure)
        return
      }
      do {
        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: jsonData)
        completion(.success(user))
      } catch {
        completion(.failure)
      }
    }
    dataTask.resume()
  }

  func getCategories(completion: @escaping (GetResourcesRequest<Category>) -> Void) {
    let url = resource.appendingPathComponent("categories")
    let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let jsonData = data else {
        completion(.failure)
        return
      }
      do {
        let decoder = JSONDecoder()
        let categories = try decoder.decode([Category].self, from: jsonData)
        completion(.success(categories))
      } catch {
        completion(.failure)
      }
    }
    dataTask.resume()
  }

  func delete() {
    guard let token = Auth().token else {
      Auth().logout()
      return
    }
    var urlRequest = URLRequest(url: resource)
    urlRequest.httpMethod = "DELETE"
    urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let dataTask = URLSession.shared.dataTask(with: urlRequest)
    dataTask.resume()
  }

  func add(category: Category, completion: @escaping (CategoryAddResult) -> Void) {
    guard let categoryID = category.id else {
      completion(.failure)
      return
    }
    guard let token = Auth().token else {
      Auth().logout()
      return
    }
    let url = resource.appendingPathComponent("categories").appendingPathComponent("\(categoryID)")
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "POST"
    urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let dataTask = URLSession.shared.dataTask(with: urlRequest) { _, response, _ in
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure)
        return
      }
      guard httpResponse.statusCode == 200 else {
        if httpResponse.statusCode == 401 {
          Auth().logout()
        }
        completion(.failure)
        return
      }
      completion(.success)
    }
    dataTask.resume()
  }
}
