//
//  TablesTableTableViewController.swift
//  geoMessenger
//
//  Created by chengen Zheng on 2017/10/29.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import Firebase

class FriendTableViewController: UITableViewController {
    
    // create instance of your Struct for the Firebase JSON object here
    var items: [UserItem] = []
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadDataFromFirebase()
    {
        // where MyUsers is the name of the JSON node/table holding Userinfo
        ref.child("MyUsers").observe(.value, with: { snapshot in
            //print(snapshot.value!)
            var newItems: [UserItem] = []
            
            // loop through the children and append them to the new array
            for dbItem in snapshot.children.allObjects {
                let gItem = (snapshot: dbItem )
                //print(gItem.value!)
                
                // convert the snapshot JSON value to your Struct type
                let newValue = UserItem(snapshot:gItem as! DataSnapshot)
                
//                let newValue = UserItem(snapshot: gItem as! DataSnapshot, firstName: <#String#>)
                newItems.append(newValue)
            }
            
            // replace the old array
            self.items = newItems.sorted{$0.lastName < $1.lastName} // sorting by lastname
            // reload the UITableView
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // add a margin to the top of the tableView
        self.tableView.contentInset = UIEdgeInsets(top: 40,left: 0,bottom: 0,right: 0)
        
        loadDataFromFirebase()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count // change from 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        let userItem = items[indexPath.row]
        
        cell.textLabel?.text = userItem.firstName
        cell.detailTextLabel?.text = userItem.lastName
        
        toggleCellCheckbox(cell, isCompleted: userItem.isApproved)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        var userItem = items[indexPath.row]
        let toggledCompletion = !userItem.isApproved
        
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        userItem.isApproved = toggledCompletion
        tableView.reloadData()
        
        let user = User()
        user.id = userItem.key
        
//        user.setValuesForKeys(dictionary)
        self.showChatControllerForUser(user: user)
    }
    
    func showChatControllerForUser(user: User) {
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.user = user
        navigationController?.pushViewController(chatController, animated: true)
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Add code to delete it from Firebase
            let pk = items[indexPath.row].key // get the primary key value for the current item
            ref.child("MyUsers").child(pk).removeValue() // delete by PK from firebase
            
            // Delete the row from the data source
            items.remove(at: indexPath.row)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


