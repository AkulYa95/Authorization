//
//  UserInformationViewController.swift
//  Authorization
//
//  Created by Ярослав Акулов on 17.09.2022.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet private weak var roleIDLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    var user: UserInfo?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = user else { return }
        tableView.dataSource = self
        roleIDLabel.text = user.roleID
        userNameLabel.text = user.userName
        emailLabel.text = user.email
    }
}

extension UserInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.permissions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else { return nil }
        return "Permissions"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let user = user else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user.permissions[indexPath.row]
        return cell
    }
}
