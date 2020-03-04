

import UIKit

class AddToCategoryTableViewController: UITableViewController {

  // MARK: - Properties
  var categories: [Category] = []
  var selectedCategories: [Category]!
  var acronym: Acronym!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }

  func loadData() {

  }
}

// MARK: - UITableViewDataSource
extension AddToCategoryTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let category =  categories[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    cell.textLabel?.text = category.name

    let isSelected = selectedCategories.contains { element in
      element.name == category.name
    }

    if isSelected {
      cell.accessoryType = .checkmark
    }

    return cell
  }
}
