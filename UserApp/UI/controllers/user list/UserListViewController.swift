//
//  UserListViewController.swift
//  UserApp
//
//  Created by Nithin Sasankan on 01/12/22.
//

import Foundation
import UIKit

class UserListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var userList:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildContentView()
        UserRepo.shared.getAllUsers { users in
            self.userList = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func buildContentView() {
        self.title = "User List"
        tableView.dataSource = self
    }
}

// UITableViewDataSource functions
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserListCell = tableView.dequeueReusableCell(withIdentifier: "UserListCell") as! UserListCell
        cell.configure(with: userList[indexPath.row])
        return cell
    }
}

class UserListCell: UITableViewCell {
    @IBOutlet var userIdLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(with user: User) {
        self.userIdLabel.text = "ID: \(user.id)"
        self.titleLabel.text = user.title
        self.bodyLabel.text = user.body
    }
}
