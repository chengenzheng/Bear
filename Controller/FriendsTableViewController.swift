//
//  NewMessageController.swift
//  Messenger
//
//  Created by Alexei Kukhto on 9/2/17.
//  Copyright © 2017 Alexei Kukhto. All rights reserved.
//

import UIKit
import Firebase

class FriendsTableViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.id = snapshot.key
                
                if user.id != Auth.auth().currentUser?.uid
                {
                    user.email = dictionary["email"] as? String
                    user.profileImageURL = dictionary["profileImageURL"] as? String
                    user.name = dictionary["name"] as? String
                    //                user.setValuesForKeys(dictionary)
                    self.users.append(user)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                }
                
                }
            }
        }, withCancel: nil)
        
        Database.database().reference().child("users").observe(.childChanged) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let uid = snapshot.key
                for user in self.users {
                    if uid == user.id{
                        user.name = dictionary["name"] as? String
                         user.profileImageURL = dictionary["profileImageURL"] as? String
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userChanged"), object: uid)
                            
                        }
                        break
                    }
                }
            }
        }
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if let profileImageURL = user.profileImageURL {
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageURL)

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let user = self.users[indexPath.row]
        self.showChatControllerForUser(user: user)
        
//       navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>) self.messagesController?.showChatControllerForUser(user: user)
//        dismiss(animated: true) {
//            let user = self.users[indexPath.row]
//            self.messagesController?.showChatControllerForUser(user: user)
//        }
    }
    func showChatControllerForUser(user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
}


