//
//  Presenter.swift
//  Authorization
//
//  Created by Ярослав Акулов on 16.09.2022.
//

import Foundation

protocol Presenter {
    func showAlertWithMessage(_ message: String)
    func showActionAlertWithMessage(_ message: String,
                                    actionButtonTitle: String,
                                    mainAction: @escaping(() -> Void),
                                    cancelAction: @escaping(() -> Void))
}
