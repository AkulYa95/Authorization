//
//  LoaderViewController.swift
//  Authorization
//
//  Created by Ярослав Акулов on 15.09.2022.
//

import UIKit

class LoaderViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserInfo()
    }
    
    private func getUserInfo() {
        NetworkManager.shared.getUserInfo { info, sessionError  in
            if let sessionError = sessionError {
                switch sessionError {
                case .responseStatusCodeErr(let int):
                    if int == 401 {
                        self.presentViewController(self.viewController(identifier: .authorization))
                        return
                    }
                case .noToken:
                    self.presentViewController(self.viewController(identifier: .authorization))
                    return
                default:
                    break
                }
                self.showActionAlertWithMessage(sessionError.errorDescription,
                                                actionButtonTitle: "Repeat") {
                    self.getUserInfo()
                } cancelAction: {
                    self.activityIndicator.stopAnimating()
                }
            }
            guard let info = info,
                  let controller = self.viewController(identifier: .userInfo) as? UserInfoViewController else {
                return
            }
            controller.user = info
            self.presentViewController(controller)
        }
    }
}
