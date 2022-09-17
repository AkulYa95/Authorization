//
//  UserInfo.swift
//  Authorization
//
//  Created by Ярослав Акулов on 13.09.2022.
//

import Foundation

struct UserInfo: Codable {
    let roleID: String?
    let userName: String?
    let email: String?
    let permissions: [String]
    
    private enum CodingKeys: String, CodingKey {
        case roleID = "roleId"
        case userName = "username"
        case email
        case permissions
    }
}
