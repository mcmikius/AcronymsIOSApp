

import UIKit

class ErrorPresenter {

  static func showError(message: String, on viewController: UIViewController?, dismissAction: ((UIAlertAction) -> Void)? = nil) {
    weak var vc = viewController
    DispatchQueue.main.async {
      let alert = UIAlertController(title: "Error",
                                    message: message,
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: dismissAction))
      vc?.present(alert, animated: true)
    }
  }
}
