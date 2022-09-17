//  ViewController.swift
//  Authorization
//
//  Created by Ярослав Акулов on 12.09.2022.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var authorizationButton: UIButton!
    
    private var loader: LoaderView = LoaderView(frame: UIScreen.main.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTextFields()
        configureButton()
    }

    @IBAction func authorizationButtonAction(_ sender: UIButton) {
        guard let username = usernameTextField.text,
              let password = passwordTextField.text
        else {
            return
        }
        loader.showLoader()
        NetworkManager.shared.signInWith(username: username, password: password) { sessionError in
            guard let sessionError = sessionError else {
                self.getInfo()
                return
            }
            self.loader.hideLoader()
            self.showAlertWithMessage(sessionError.errorDescription)
        }
    }
    
    private func getInfo() {
        NetworkManager.shared.getUserInfo { info, sessionError in
            self.loader.hideLoader()
            guard let sessionError = sessionError else {
                guard let info = info,
                      let controller = self.viewController(identifier: .userInfo) as? UserInfoViewController else {
                    return
                }
                controller.user = info
                self.presentViewController(controller)
                return
            }
            self.showAlertWithMessage(sessionError.errorDescription)
        }
    }
    
    private func configureTextFields() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.becomeFirstResponder()
    }
    
    private func configureButton() {
        authorizationButton.layer.cornerRadius = 15
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
