import UIKit

class PinsLogic: NSObject {
    weak var coordinator: MainCoordinator?
    
    var reloadTableView: (() -> Void)?

    private let pinsManager: PinsManager
    private let cellIdentifier: String
    
    init(pinsManager: PinsManager) {
        self.pinsManager = pinsManager
        cellIdentifier = "cellIdentifier"
    }
    
    func setupTableView(_ tableView: UITableView) {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: cellIdentifier
        )
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addPin(_ pin: Pin) {
        pinsManager.addPin(pin)
    }
}

extension PinsLogic: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pinsManager.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = pinsManager.getName(ofPinAt: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetails(
            pin: pinsManager.pins[indexPath.row],
            saveCompletion: { [weak self] pin in
                if let oldPin = self?.pinsManager.pins[indexPath.row] {
                    self?.pinsManager.repleacePin(oldPin, for: pin)
                    self?.reloadTableView?()
                }
            },
            deleteCompletion: { [weak self] in
                self?.pinsManager.removePin(at: indexPath.row)
                self?.reloadTableView?()
            }
        )
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            self?.pinsManager.removePin(at: indexPath.row)
            self?.reloadTableView?()
            completionHandler(true)
        }
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
         
        return swipeConfiguration
    }
}
