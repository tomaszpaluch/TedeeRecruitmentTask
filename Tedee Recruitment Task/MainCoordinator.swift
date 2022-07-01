import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }

    func initalizeRoot()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func initalizeRoot() {
        let search = PinsViewController(
            logic: .init(
                pinsManager: .init(
                    pinsPersistance: .init()
                )
            )
        )
        
        search.coordinator = self
        
        navigationController.pushViewController(search, animated: false)
    }
    
    func showDetails(
        pin: Pin? = nil,
        saveCompletion: @escaping (Pin) -> Void,
        deleteCompletion: (() -> Void)? = nil
    ) {
        let details = DetailsViewController(
            logic: .init(
                pin: pin
            ),
            savePinCompletion: saveCompletion,
            deletePinCompletion: deleteCompletion
        )
        
        details.coordinator = self

        navigationController.pushViewController(details, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
