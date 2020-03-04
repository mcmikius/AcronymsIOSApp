

import UIKit

class CreateCategoryTableViewController: UITableViewController {

  // MARK: - IBOutlets
  @IBOutlet weak var nameTextField: UITextField!

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    nameTextField.becomeFirstResponder()
  }

  // MARK: - IBActions
  @IBAction func cancel(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func save(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}
