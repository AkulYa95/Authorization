//
//  Extension + UIViewController.swift
//  Authorization
//
//  Created by Ярослав Акулов on 15.09.2022.
//

import UIKit

extension UIViewController: Presenter {
    func showAlertWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActionAlertWithMessage(_ message: String,
                                    actionButtonTitle: String,
                                    mainAction: @escaping(() -> Void),
                                    cancelAction: @escaping(() -> Void)) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionButtonTitle, style: .default) { _ in mainAction() }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in cancelAction() }
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: Router {
    func presentViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
    
    func viewController(identifier: ViewControllerIdentifier) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(identifier: identifier.rawValue)
        return destinationVC
    }
}
