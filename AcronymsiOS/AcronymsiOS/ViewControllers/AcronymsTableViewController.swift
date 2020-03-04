

import UIKit

class AcronymsTableViewController: UITableViewController {

  // MARK: - Properties

  var acronyms: [Acronym] = []
  let acronymsRequest = ResourceRequest<Acronym>(resourcePath: "acronyms")

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh(nil)
  }

  func refresh() {
    if refreshControl != nil {
      refreshControl?.beginRefreshing()
    }
    refresh(refreshControl)
  }

  @IBAction func refresh(_ sender: UIRefreshControl?) {
    acronymsRequest.getAll { [weak self] acronymResult in
      DispatchQueue.main.async {
        sender?.endRefreshing()
      }

      switch acronymResult {
      case .failure:
        ErrorPresenter.showError(message: "There was an error getting the acronyms", on: self)
      case .success(let acronyms):
        DispatchQueue.main.async { [weak self] in
          self?.acronyms = acronyms
          self?.tableView.reloadData()
        }
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AcronymsToAcronymDetail" {
      guard let destination = segue.destination as? AcronymDetailTableViewController,
        let indexPath = tableView.indexPathForSelectedRow else {
          return
      }

      destination.acronym = acronyms[indexPath.row]
    }
  }
}

// MARK: - UITableViewDataSource
extension AcronymsTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return acronyms.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let acronym = acronyms[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "AcronymCell", for: indexPath)
    cell.textLabel?.text = acronym.short
    cell.detailTextLabel?.text = acronym.long
    return cell
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if let id = acronyms[indexPath.row].id {
      let acronymDetailRequester = AcronymRequest(acronymID: id)
      acronymDetailRequester.delete()
    }

    acronyms.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}
