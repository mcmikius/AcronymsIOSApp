

import UIKit

class CreateAcronymTableViewController: UITableViewController {

  @IBOutlet weak var acronymShortTextField: UITextField!
  @IBOutlet weak var acronymLongTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    acronymShortTextField.becomeFirstResponder()
  }

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    navigationController?.popViewController(animated: true)
  }

  @IBAction func save(_ sender: UIBarButtonItem) {
    guard let shortText = acronymShortTextField.text, !shortText.isEmpty else {
      ErrorPresenter.showError(message: "You must specify an acronym!", on: self)
      return
    }
    guard let longText = acronymLongTextField.text, !longText.isEmpty else {
      ErrorPresenter.showError(message: "You must specify a meaning!", on: self)
      return
    }
    let acronym = Acronym(short: shortText, long: longText, userID: UUID())

    ResourceRequest<Acronym>(resourcePath: "acronyms").save(acronym) { [weak self] result in
      switch result {
      case .failure:
        ErrorPresenter.showError(message: "There was a problem saving the acronym", on: self)
      case .success:
        DispatchQueue.main.async { [weak self] in
          self?.navigationController?.popViewController(animated: true)
        }
      }
    }
  }
}
