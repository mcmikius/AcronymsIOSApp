

import Foundation

enum AcronymUserRequestResult {
  case success(User)
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
  func getUser(
    completion: @escaping (AcronymUserRequestResult) -> Void) {
    
    let url = resource.appendingPathComponent("user")
    let dataTask = URLSession.shared
      .dataTask(with: url) { data, _, _ in
        guard let jsonData = data else {
          completion(.failure)
          return
        }
        do {
          let user = try JSONDecoder()
            .decode(User.self, from: jsonData)
          completion(.success(user))
        } catch {
          completion(.failure)
        }
    }
    dataTask.resume()
  }
  
  func getCategories(
    completion: @escaping (GetResourcesRequest<Category>) -> Void
  ) {
    let url = resource.appendingPathComponent("categories")
    let dataTask = URLSession.shared
      .dataTask(with: url) { data, _, _ in
        guard let jsonData = data else {
          completion(.failure)
          return
        }
        do {
          let categories = try JSONDecoder()
            .decode([Category].self, from: jsonData)
          completion(.success(categories))
        } catch {
          completion(.failure)
        }
    }
    dataTask.resume()
  }
  
  func update(
    with updateData: Acronym,
    completion: @escaping (SaveResult<Acronym>) -> Void
  ) {
    do {
      var urlRequest = URLRequest(url: resource)
      urlRequest.httpMethod = "PUT"
      urlRequest.httpBody = try JSONEncoder().encode(updateData)
      urlRequest.addValue("application/json",
                          forHTTPHeaderField: "Content-Type")
      let dataTask = URLSession.shared
        .dataTask(with: urlRequest) { data, response, _ in
          guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200,
            let jsonData = data
            else {
              completion(.failure)
              return
          }
          do {
            let acronym = try JSONDecoder()
              .decode(Acronym.self, from: jsonData)
            completion(.success(acronym))
          } catch {
            completion(.failure)
          }
      }
      dataTask.resume()
    } catch {
      completion(.failure)
    }
  }
  
  func delete() {
    var urlRequest = URLRequest(url: resource)
    urlRequest.httpMethod = "DELETE"
    let dataTask = URLSession.shared.dataTask(with: urlRequest)
    dataTask.resume()
  }
}
