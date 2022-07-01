import UIKit

class PinsViewController: UIViewController {
    var coordinator: MainCoordinator? {
        get { logic.coordinator }
        set { logic.coordinator = newValue }
    }
    
    private let logic: PinsLogic
    private let tableView: UITableView
    
    init(logic: PinsLogic) {
        self.logic = logic
        
        tableView = UITableView()
        
        logic.setupTableView(tableView)
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.title = "Pins"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "+",
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )

        view.addSubview(tableView)
        
        setupTableViewConstraints()
        
        logic.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addTapped() {
        coordinator?.showDetails { [weak self] pin in
            self?.logic.addPin(pin)
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
