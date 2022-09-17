//
//  Router.swift
//  Authorization
//
//  Created by Ярослав Акулов on 16.09.2022.
//

import UIKit

protocol Router {
    func presentViewController(_ viewController: UIViewController)
    func viewController(identifier: ViewControllerIdentifier) -> UIViewController
}
