import Foundation
import UIKit

final class AlertControllerSingleton {
    static let shared = AlertControllerSingleton()
    private init() {  }
    
    func showError(_ error: String, presentFrom viewController: UIViewController) {
        let ac = UIAlertController(title: ERROR, message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: OK, style: .default))
        viewController.present(ac, animated: true)
    }
    
    func showInfo(_ info: String, presentFrom viewController: UIViewController) {
        let ac = UIAlertController(title: INFO, message: info, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: OK, style: .default))
        viewController.present(ac, animated: true)
    }
    
    func showYesNoAlert(title: String, message: String, presentFrom viewController: UIViewController, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: YES, style: .default) { _ in
            completionHandler()
        })
        ac.addAction(UIAlertAction(title: NO, style: .cancel))
        viewController.present(ac, animated: true)
    }
    
    func showDoneCancelAlert(title: String, message: String, presentFrom viewController: UIViewController, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: DONE, style: .default) { _ in
            completionHandler()
        })
        ac.addAction(UIAlertAction(title: CANCEL, style: .cancel))
        viewController.present(ac, animated: true)
    }
    
    func showOKCancelAlert(title: String, message: String, presentFrom viewController: UIViewController, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: OK, style: .default) { _ in
            completionHandler()
        })
        ac.addAction(UIAlertAction(title: CANCEL, style: .cancel))
        viewController.present(ac, animated: true)
    }
    
    func showAlertWithNActions(title: String, message: String, actionsDictionary: [String: () -> Void], presentFrom viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for key in actionsDictionary.keys {
            ac.addAction(UIAlertAction(title: key, style: .default) { _ in
                if let action = actionsDictionary[key] {
                    action()
                }
            })
        }
        ac.addAction(UIAlertAction(title: CANCEL, style: .cancel))
        viewController.present(ac, animated: true)
    }
    
    func showActionSheetWithNActions(title: String, message: String, actionsDictionary: [String: () -> Void], presentFrom viewController: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for key in actionsDictionary.keys {
            ac.addAction(UIAlertAction(title: key, style: .default) { _ in
                if let action = actionsDictionary[key] {
                    action()
                }
            })
        }
        ac.addAction(UIAlertAction(title: CLOSE, style: .cancel))
        viewController.present(ac, animated: true)
    }
}
