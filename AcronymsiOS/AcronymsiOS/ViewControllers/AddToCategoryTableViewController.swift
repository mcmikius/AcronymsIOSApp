

import UIKit

class AddToCategoryTableViewController: UITableViewController {

  var categories: [Category] = []
  var selectedCategories: [Category]!
  var acronym: Acronym!

  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }

  func loadData() {
    let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    categoriesRequest.getAll { [weak self] result in
      switch result {
      case .failure:
        ErrorPresenter.showError(message: "There was an error getting the categories", on: self) { _ in
          self?.navigationController?.popViewController(animated: true)
        }
      case .success(let categories):
        self?.categories = categories
        DispatchQueue.main.async { [weak self] in
          self?.tableView.reloadData()
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension AddToCategoryTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    let category =  categories[indexPath.row]
    cell.textLabel?.text = category.name
    let isSelected = selectedCategories.contains { element in
      element.name == category.name
    }
    if isSelected {
      cell.accessoryType = .checkmark
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let category = categories[indexPath.row]
    guard let acronymID = acronym.id else {
      let message = """
      There was an error adding the acronym
      to the category - the acronym has no ID
      """
      ErrorPresenter.showError(message: message, on: self)
      return
    }
    let acronymRequest = AcronymRequest(acronymID: acronymID)
    acronymRequest.add(category: category) { [weak self] result in
      switch result {
      case .success:
        DispatchQueue.main.async { [weak self] in
          self?.navigationController?.popViewController(animated: true)
        }
      case .failure:
        let message = """
        There was an error adding the acronym
        to the category
        """
        ErrorPresenter.showError(message: message, on: self)
      }
    }
  }
}
